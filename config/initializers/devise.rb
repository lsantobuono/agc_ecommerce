Devise.secret_key = "f7fedb6d79fab85c5593b97c52b5883d8d0fd9926471732cd0dc2608d661f0ba0cd61dd1e3ad7c5178ac200472a0ff4ff0f2"

Devise.setup do |config|
  # Required so users don't lose their carts when they need to confirm.
  config.allow_unconfirmed_access_for = nil

  # Fixes the bug where Confirmation errors result in a broken page.
  config.router_name = :spree

  # Add any other devise configurations here, as they will override the defaults provided by spree_auth_devise.
end
