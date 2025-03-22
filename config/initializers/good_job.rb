# Add session middleware for the engine
GoodJob::Engine.middleware.use(ActionDispatch::Cookies)
GoodJob::Engine.middleware.use(ActionDispatch::Session::CookieStore)