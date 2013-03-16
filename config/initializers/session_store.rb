# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#Dmrps::Application.config.session_store :active_record_store

# Use Memcached Store for sessions
Dmrps::Application.config.session_store ActionDispatch::Session::CacheStore, expire_after: 10.minutes
