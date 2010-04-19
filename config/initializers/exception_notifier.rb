DasPhotowall::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[photostre.am] ",
    :sender_address => %{"photostre.am" <info@photostre.am>},
    :exception_recipients => %w{tomk32@tomk32.de}