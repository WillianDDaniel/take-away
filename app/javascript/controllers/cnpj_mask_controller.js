import { Controller } from "@hotwired/stimulus";
import Inputmask from "inputmask";

export default class extends Controller {
  static targets = ["cnpj"];

  connect() {
    let cnpjIM = new Inputmask.default("99.999.999/9999-99", {
      clearMaskOnLostFocus: true,
      placeholder: "_",
      removeMaskOnSubmit: true,
    })
    cnpjIM.mask(this.cnpjTarget)
  }
}
