import { Application } from "@hotwired/stimulus"
import "./controllers/menu_tabs"


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
