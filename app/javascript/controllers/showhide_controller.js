import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="showhide"
export default class extends Controller {
  static targets =["input","output"];
  static values={showif:String}
  connect() {
    
  }
  toggle(){
    if (this.inputTarget.value=="change"){
      if(this.outputTarget.hidden==true){
        this.outputTarget.hidden=false;
      }
      else{
        this.outputTarget.hidden=true;
      }
    }
    
  }
}
