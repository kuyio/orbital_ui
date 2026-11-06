import { Application } from "@hotwired/stimulus"

let application
if (window.Stimulus) {
  application = window.Stimulus
} else {
  application = Application.start()
  application.debug = false
  window.Stimulus = application
}

import AccordionController from "./controllers/accordion_controller"
import AvatarController from "./controllers/avatar_controller"
import MenuController from "./controllers/menu_controller"
import MenuSubController from "./controllers/menu_sub_controller"
import ModalController from "./controllers/modal_controller"
import PopoverController from "./controllers/popover_controller"
import SelectController from "./controllers/select_controller"

application.register("orbital-avatar", AvatarController)
application.register("o-accordion", AccordionController)
application.register("orbital-modal", ModalController)
application.register("orbital-popover", PopoverController)
application.register("orbital-menu", MenuController)
application.register("orbital-menu-sub", MenuSubController)
application.register("orbital-select", SelectController)

document.addEventListener("click", (event) => {
  const trigger = event.target.closest("[data-open-modal], [data-open-dialog]")
  if (!trigger) return

  event.preventDefault()
  const id = trigger.dataset.openModal || trigger.dataset.openDialog
  const modal = document.getElementById(id)
  if (!modal) return

  const controller = application.getControllerForElementAndIdentifier(modal, "orbital-modal")
  if (controller) controller.show()
})

export { application }
