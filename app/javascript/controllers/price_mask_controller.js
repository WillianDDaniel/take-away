import { Controller } from "@hotwired/stimulus";
import Inputmask from "inputmask";

export default class extends Controller {
  static targets = ["price"];

  connect() {
    let im = new Inputmask.default("R$ 9{1,},99", {
      numericInput: true,
      clearMaskOnLostFocus: true,
      placeholder: "0",
      removeMaskOnSubmit: true,
    })
    im.mask(this.priceTarget)
  }
}
