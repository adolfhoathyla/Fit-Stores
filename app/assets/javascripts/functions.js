function showMe (box) {
        
    var chboxs = document.getElementsByName("store[delivery]");
    var vis = "none";
    var required = false;
    for(var i=0;i<chboxs.length;i++) { 
        if(chboxs[i].checked){
         vis = "block";
         required = true;
            break;
        }
    }
    document.getElementById(box).style.display = vis;
    document.getElementById("store_value_per_km").required = required;


}

function onClickTypeOfState () {
        
    var selectTypeOfState = document.getElementById("product_type_of_state");
    var valueTypeOfState = selectTypeOfState.options[selectTypeOfState.selectedIndex].value;
    var textFieldWeight = document.getElementById("product_weight");
    if (valueTypeOfState == "Pó") {
        textFieldWeight.type = "po";
        $("[type=po]").maskMoney({suffix:' gramas', precision:0, thousands:'', decimal:'', symbolStay: true, allowZero: false});
    } else if (valueTypeOfState == "Líquido") {
        textFieldWeight.type = "liquido";
        $("[type=liquido]").maskMoney({suffix:' ml', precision:0, thousands:'', decimal:'', symbolStay: true, allowZero: false});
    } else if (valueTypeOfState == "Comprimido") {
        textFieldWeight.type = "comprimido"
        $("[type=comprimido]").maskMoney({suffix:' comprimidos', precision:0, thousands:'', decimal:'', symbolStay: true, allowZero: false});
    }
    textFieldWeight.focus();

}

$(document).ready(function() {
    $('#tabela').DataTable();
} );