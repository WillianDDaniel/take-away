import { Controller } from "@hotwired/stimulus";
import Inputmask from "inputmask";

export default class extends Controller {
  static targets = ["phone"];

  connect() {
    const phoneIM = new Inputmask.default("(99) 999999999", {
      clearMaskOnLostFocus: true,
      placeholder: "_",
      removeMaskOnSubmit: true,
    })
    phoneIM.mask(this.phoneTarget)
  }
}
