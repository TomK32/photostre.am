# Be sure to restart your server when you modify this file.

DasPhotowall::Application.config.secret_token = '84f3c2d01ef22e39fadb7a93fab0f36e4c5d1068850e2ef194135416ad105e823101d8a512fb4041be021367ff28fd76a051cb0c532d0b8d326de9cc9ce08df5'

DasPhotowall::Application.config.session_store :cookie_store, :key => '_das_photowall_session', :expire_after => 1.month

