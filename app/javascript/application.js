// Import Turbo for Hotwire
import "@hotwired/turbo-rails"

// Initialize Rails UJS (for handling method: :delete and confirmation dialogs)
import { start } from "@rails/ujs"
start()

// Import Bootstrap
import "bootstrap"

// Import controllers (for Hotwire if you're using any)
import "controllers"
