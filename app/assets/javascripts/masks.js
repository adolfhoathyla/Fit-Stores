$(function(){
   	$("#address_cep").mask("99999-999");
   	$("#store_cnpj").mask("99.999.999/9999-99");
   	$("[type=po]").maskMoney({suffix:' gramas', precision:0, thousands:'', decimal:'', symbolStay: true, allowZero: false});
    $("[type=liquido]").maskMoney({suffix:' ml', precision:0, thousands:'', decimal:'', symbolStay: true, allowZero: false});
    $("[type=comprimido]").maskMoney({suffix:' comprimidos', precision:0, thousands:'', decimal:'', symbolStay: true, allowZero: false});
   	$("#on_sale_percentage_percentage").maskMoney({suffix:' %', thousands:'', decimal:',', symbolStay: true});
   	$("[type=price]").maskMoney({prefix:'R$ ', thousands:'', decimal:',', symbolStay: true, allowZero: false});
   	$('[type=telephone]')    
        .mask("(99)9999-9999?9")    
        .keydown(function() {  
            var $elem = $(this);  
            var tamanhoAnterior = this.value.replace(/\D/g, '').length;  
              
            setTimeout(function() {   
                var novoTamanho = $elem.val().replace(/\D/g, '').length;  
                if (novoTamanho !== tamanhoAnterior) {  
                    if (novoTamanho === 11) {    
                        $elem.unmask();    
                        $elem.mask("(99)99999-9999");    
                    } else if (novoTamanho === 10) {    
                        $elem.unmask();    
                        $elem.mask("(99)9999-9999?9");    
                    }  
                }  
            }, 1);  
        });
});


// jQuery(document).ready(function() {
//     //Inicio Mascara Telefone
//     jQuery("#store_telephone").mask("(99)9999-9999?9").ready(function(event) {
//         var target, phone, element;
//         target = (event.currentTarget) ? event.currentTarget : event.srcElement;
//         phone = target.value.replace(/\D/g, '');
//         element = $(target);
//         element.unmask();
//         if(phone.length > 10) {
//             element.mask("(99)99999-999?9");
//         } else {
//             element.mask("(99)9999-9999?9");
//         }
//     });
// });