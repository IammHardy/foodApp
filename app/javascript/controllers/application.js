import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

const application = Application.start()

// auto-load all controllers from this folder
const context = require.context(".", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

window.Stimulus = application
export { application }
