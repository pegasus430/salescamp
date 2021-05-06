import { uuid } from 'main/utils'
class Milestone{
  constructor(elem,parent){
    this._elem = elem;
    this.parent = parent;
    this._setUniqueId();
    this.previewElement();
    this._bindEvents();
  }

  _bindEvents(){
    $(this._elem).find('.w-input').on('change',this.change.bind(this));
    $(this._elem).find('.w-select').on('change',this.change.bind(this));
  }

  _setUniqueId(){
    if(this._elem.id == ""){
      this._elem.id = "milestone_"+uuid();
    }
  }

  _getId(){
    let index = $(this._elem).find('.w-input')[0].name.match(/\[[0-9]+\]/)[0].match(/[0-9]+/)[0];
    let id_elem = $("input[name=\"campaign[milestones_attributes]["+index+"][id]\"]")[0];
    if(id_elem){
      return id_elem.value;
    }
  }

  change(event){
    let rewardCaption = $("#"+this._elem.id+">.w-input")[0].value,
    referralCount = this.referralCount(),
    previewElement = this.previewElement();

    previewElement.find('.reward-text')[0].innerHTML = rewardCaption;
    previewElement.attr('data-step', referralCount);

    //this.parent.sort();
  }

  /*createPreviewElement(){
    let id = "milestone_view_"+this._elem.id;
    let template = "<div class=\"reward-div w-clearfix\" id=\""+ id + " \"> <div class=\"referral-target not-reached\"> 0 </div> <div class=\"reward-text\"> </div> </div>";
    let new_elem = $(template);
    $('.rewards-div').append(new_elem);
    return new_elem;
  }*/

  createPreviewElement(){
    let id = "milestone_view_"+this._elem.id;
    let template = "<li id=\""+ id + " \" data-step=0 > <span class=\"reward-text\"></span></li>";
    let new_elem = $(template);
    $('.progress-indicator').append(new_elem);
    return new_elem;
  }


  removePreview(){
    this.previewElement().remove();
  }

  id(){
    return this._elem.id;
  }

  isEqual(milestone){
    return this.id() == milestone.id();
  }

  previewElement(){
    if(!this._previewElement){
      let id = this._getId()
      if(!!id){
        this._previewElement = $('#milestone_view_'+id);
      }else{
        this._previewElement = this.createPreviewElement();
      }
    }
    return this._previewElement;
  }

  referralCount(){
    return $(this._elem).find('.w-select')[0].value;
  }

}
class Milestones{
  constructor(){
    this._milestones = [];
    $('#milestones>.nested-fields').toArray().forEach((elem) => {
      let milestone = new Milestone(elem,this);
      this.add(milestone);
    });
    this._bindEvents();
  }
  _bindEvents(){
    $('#milestones').on('cocoon:after-insert',this.afterInsert.bind(this));
    $('#milestones').on('cocoon:after-remove',this.afterRemove.bind(this));
  }
  add(milestone){
    if(!this.contains(milestone)){
      this._milestones.push(milestone);
    }
  }

  afterInsert(e,milestone){
    let ms = new Milestone(milestone[0],this);
    this.add(ms);
  }

  afterRemove(e,milestone){
    let ms = this.find(milestone[0].id);
    ms.removePreview();
    let i = this._milestones.indexOf(ms);
    if(i != -1) {
      this._milestones.splice(i, 1);
    }
  }

  contains(milestone){
    let result = this._milestones.find((ms) => {
      return ms.isEqual(milestone);
    });
    return !!result;
  }

  find(id){
    return this._milestones.find((milestone)=>{
      return id === milestone.id();
    });
  }

  sort(){
    this._milestones.sort((a,b)=>{
      if (+a.referralCount() > +b.referralCount()) {
        return 1;
      }
      if (+a.referralCount() < +b.referralCount()) {
        return -1;
      }
      // a must be equal to b
      return 0;
    });
    let previewElements = this._milestones.map((m) => {return m.previewElement()});
    $('.rewards-div').append(previewElements);
  }

}

let milestones = new Milestones();
