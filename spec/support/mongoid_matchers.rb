# Adaption of thoughbot-should association matchers to mongoid
module Rspec # :nodoc:
  module Matchers

    # Ensure a belongs_to_related relation between two collections.
    #
    #   it { should belong_to_related(:musician) }
    #
    def belong_to_related(name)
      AssociationMatcher.new(:belongs_to_related, name)
    end

    # Ensures a has_many_related relation between two collections
    #
    # Example:
    #   it { should_have_many_related(:band) }
    #
    def have_many_related(name)
      AssociationMatcher.new(:has_many, name)
    end

    # Ensure a has_on_related relation between two collections
    #
    # Example:
    #   it { should have_one_related(:band_leader) } # unless hindu
    #
    def have_one_related(name)
      AssociationMatcher.new(:has_one, name)
    end

    # Ensures a embed_many relation where objects are stored as an
    # Array inside a parent objects
    #
    #   it { should embed_many(:instruments).inverse_of(:musician) }
    #
    # Options:
    #   :inverse_of
    #
    def embed_many(name)
      AssociationMatcher.new(:embeds_many, name)
    end

    # Ensures a embed_many relation.
    #
    #   it { should embed_one(:manufacturer).inverse_of(:instrument) }
    #
    # Options:
    #   :inverse_of
    #
    def embed_one(name)
      AssociationMatcher.new(:embeds_one, name)
    end

    # Ensures a embedded_in relation.
    #
    #   it { should embedded_in(:musician).inverse_of(:instruments) }
    #   it { should embedded_in(:instrument).inverse_of(:manufacturer) }
    #
    # Options:
    #   :inverse_of
    #
    def be_embedded_in(name)
      AssociationMatcher.new(:embedded_in, name)
    end

    class AssociationMatcher # :nodoc:
      def initialize(macro, name)
        @macro = macro
        @name  = name
      end

      def inverse_of(inverse_of)
        @inverse_of = inverse_of
        self
      end

      def matches?(subject)
        @subject = subject
        association_exists? &&
          macro_correct? &&
          inverse_exists?
      end

      def failure_message
        "Expected #{expectation} (#{@missing})"
      end

      def negative_failure_message
        "Did not expect #{expectation}"
      end

      def description
        description = "#{macro_description} #{@name}"
        description += " inverse of #{@inverse_of}" if @inverse_of
        description
      end

      protected

      def association_exists?
        if reflection.nil?
          @missing = "no association called #{@name}"
          false
        else
          true
        end
      end

      def macro_correct?
        if reflection.macro == @macro
          true
        else
          @missing = "actual association type was #{reflection.macro}"
          false
        end
      end

      def foreign_key_exists?
        !(belongs_foreign_key_missing? || has_foreign_key_missing?)
      end

      def belongs_foreign_key_missing?
        @macro == :belongs_to && !class_has_foreign_key?(model_class)
      end

      def has_foreign_key_missing?
        [:has_many, :has_one].include?(@macro) &&
          !class_has_foreign_key?(associated_class)
      end

      def class_has_foreign_key?(klass)
        if klass.column_names.include?(foreign_key.to_s)
          true
        else
          @missing = "#{klass} does not have a #{foreign_key} foreign key."
          false
        end
      end

      def model_class
        @subject.class
      end

      def associated_class
        reflection.klass
      end

      def foreign_key
        reflection.primary_key_name
      end

      def inverse_of?
        puts reflection.options
        reflection.options.inverse_of
      end

      def inverse_exists?
        inverse_of?
      end


      def reflection
        @reflection ||= model_class.associations[@name.to_s]
      end

      def expectation
        "#{model_class.name} to have a #{@macro} association called #{@name}"
      end

      def macro_description
        case @macro.to_s
        when 'belongs_to_related' then 'belong to related'
        when 'has_many_related'   then 'have many related'
        when 'has_one_related'    then 'have one related'
        when 'be_embedded_in'     then "is embedded in"
        when 'embeds_one'         then 'embeds one'
        when 'embeds_many'        then "embeds many"
        end
      end
    end

  end
end
