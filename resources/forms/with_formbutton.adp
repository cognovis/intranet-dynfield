<div class="standard-form">

<!-- section delimiter -->
<div class="standard-form-row"><div class="standard-form-section">#flexbase.Section#</div></div>

<!-- hidden fields -->
<noparse><formwidget id="_hidden_field_"></noparse>


<!-- manadatory fields -->
 <div class="standard-form-row">
    <div class="standard-form-label" style="width: 20%">
	<div class="standard-form-label-text-mandatory">
	    <label for="_mandatory_field_"><noparse><formlabel id="_mandatory_field_"></noparse></label>
        </div>
	<div class="standard-form-label-mandatory">*</div>
    </div>
    
    <div class="standard-form-text">
	  <noparse><formwidget id="_mandatory_field_"></noparse>
<!-- error message -->
          <formerror id="_mandatory_field_">
             <div class="standard-form-error" style="color:#ff0000">\@formerror._mandatory_field_;noquote@</div>
          </formerror>
<!-- help text -->
          <div class="standard-form-help-text">

              <noparse><formhelptext id="_mandatory_field_">
	<img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
		</formhelptext></noparse>
          </div>
        </div>
     </div>
 </div>

<!-- normal fields -->
 <div class="standard-form-row">
    <div class="standard-form-label" style="width: 20%">
	<div class="standard-form-label-text">
            <label for="_normal_field_"><noparse><formlabel id="_normal_field_"></noparse></label>
        </div>
    </div>
     
    <div class="standard-form-text">
          <noparse><formwidget id="_normal_field_"></noparse>
<!-- error message -->
	  <formerror id="_normal_field_">
            <div class="standard-form-error" style="color:#ff0000">\@formerror._normal_field_;noquote@</div>
          </formerror>
<!-- help text -->
          <div class="standard-form-help-text">
	     <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
	     <noparse><formhelp id="_normal_field_"></noparse>
          </div>
       </div>
    </div>
 </div>


<!-- radio and checkbox -->
 <div class="standard-form-row">
   <div class="standard-form-label" style="width: 20%">
         <div class="standard-form-label-text">&nbsp;</div>
   </div>
  <noparse>
   <formgroup id="_radio_field_">
      <div class="standard-form-text">
	    \@formgroup.widget;noquote@
            \@formgroup.label;noquote@
      </div>
   </formgroup>
  </noparse>
</div> 

<!-- form buttons -->
  <if @form_properties.mode@ eq "edit">

    <div class="standard-form-row">
      <div class="standard-form-label" style="width: 20%">
         <div class="standard-form-label-text">&nbsp;</div>
      </div>
      <div class="standard-form-text">
            <noparse><formwidget id="formbutton:ok"></noparse>
      </div>
    </div>

  </if>

</div>

