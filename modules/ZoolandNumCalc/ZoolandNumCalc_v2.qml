import QtQuick
import QtQuick.Controls

import ZmButton 1.0
//import ZoolLogView 1.0
import ZoolandNumCalc.NumCalcLog 1.0

Rectangle{
    id: r
    width: parent.width
    height: parent.height
    border.width: 1
    border.color: apps.fontColor
    radius: r.fs*0.25
    color: apps.backgroundColor
    visible: false
    property int fs: !app.appRotated?app.fs*1.5:app.fs*0.5
    onVisibleChanged: tiSearch.focus=false
    MouseArea{
        anchors.fill: parent
        onDoubleClicked: {
            //toNextArea()
        }
    }
    Column{
        id: col
        //anchors.centerIn: parent
        anchors.top: parent.top
        anchors.topMargin: r.fs
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: r.fs*0.25
        Item{width: 1; height: r.fs}
        Text{
            id: txtTit
            text:!app.appRotated?'<b>Numerología Alfanumérica</b><br><p style="font-size:'+parseInt(r.fs)+'px">Ingresa una fecha (20.6.1975) o un nombre/cadena de texto.</p>':'<b>Numerología Alfanumérica</b>'
            font.pixelSize: r.fs
            color: apps.fontColor
            width: r.width-r.fs*3
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            anchors.horizontalCenter: parent.horizontalCenter
            //visible: false
        }
        Item{width: 1; height: r.fs}
        Row{
            spacing: r.fs*0.25
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: xTiSearch
                width: r.width-botPrint.width-parent.spacing*3
                height: tiSearch.contentHeight*1.4
                color: apps.backgroundColor
                border.color:apps.fontColor
                border.width: 1
                radius: r.fs*0.25
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: 'Calcular'
                    font.pixelSize: r.fs
                    color: 'white'
                    anchors.bottom: parent.top
                }
                TextInput{
                    id: tiSearch
                    width: parent.width-r.fs*0.5
                    height: parent.height*0.8
                    color: apps.fontColor
                    font.pixelSize: r.fs
                    maximumLength: 100
                    horizontalAlignment: TextInput.AlignLeft
                    anchors.centerIn: parent
                    onTextChanged: printNumMision()
                    Keys.onReturnPressed: {
                        printNumMision()
                    }
                }

            }
            ZmButton{
                id: botPrint
                text: 'Calcular'
                fs: !app.appRotated?app.botWidth*0.85:app.botWidth*0.65
                anchors.verticalCenter: parent.verticalCenter
                onClicked:{
                    printNumMision()
                }
            }
        }
        NumCalcLog{
            id: log
            width: r.width
            height: r.height-txtTit.contentHeight-xTiSearch.height-r.fs*5
            visible: true
        }
    }
    //Cerrar esta ventana
    ZmButton{
        id: botChangeArea
        text:'\uf00d'
        fs: r.fs
        isCuad: true
        anchors.right: parent.right
        anchors.rightMargin: r.fs*0.1
        anchors.top: parent.top
        anchors.topMargin: r.fs*0.1
        onClicked: {
            r.visible=false
        }
    }

    function printNumMision(){
        var textInput = tiSearch.text.trim()
        if (textInput === "") {
            log.clear()
            log.setText('Esperando que escribas una fecha o un nombre.')
            return
        }

        // Evaluar si contiene caracteres alfabéticos (Letras)
        let contieneLetras = /[a-zA-ZñÑ]/.test(textInput)

        if (contieneLetras) {
            stringToNumerology(textInput)
            return
        }

        // Si es puramente numérico, continúa con el comportamiento original de fechas
        var finalText=''
        let mfecha=textInput.split('.')
        if(mfecha.length===1){
            let numPitDeAnio=bigNumToPitNum(parseInt(textInput), true)
            log.clear()
            log.setText('Resultado: '+numPitDeAnio)
            return
        }

        let sformula=''
        if(!mfecha[0]||!mfecha[1]||!mfecha[2]||mfecha[2].length<4){
            log.clear()
            log.setText('Esperando que escribas la fecha completa.')
            return
        }
        let d=mfecha[0]
        let m=mfecha    [1]
        let a = mfecha[2]
        let sf=''+d+'/'+m+'/'+a
        let aGetNums=getNums(sf)

        finalText+='Número de Sendero / Camino de Vida: '+aGetNums[0]+'\n'
        if(parseInt(aGetNums[3])>0){
            finalText+='Número Kármico: '+aGetNums[3]+'\n'
        }

        let msfd=(''+d).split('')
        let sfd=''+msfd[0]
        if(msfd.length>1){
            sfd +='+'+msfd[1]
        }
        let msfm=(''+m).split('')
        let sfm=''+msfm[0]
        if(msfm.length>1){
            sfm +='+'+msfm[1]
        }

        let msfa=(''+a).split('')
        let sfa=''+msfa[0]
        if(msfa.length>1){
            sfa +='+'+msfa[1]
        }
        if(msfa.length>2){
            sfa +='+'+msfa[2]
        }
        if(msfa.length>3){
            sfa +='+'+msfa[3]
        }
        let sform= sfd + '+' + sfm + '+' + sfa
        let sum=0
        let mSum=sform.split('+')
        for(var i=0;i<mSum.length;i++){
            sum+=parseInt(mSum[i])
        }
        let mCheckSum=(''+sum).split('')
        if(mCheckSum.length>1){
            let dobleDigSum=parseInt(mCheckSum[0])+parseInt(mCheckSum[1])
            sform+='='+sum+'='+dobleDigSum
            let mCheckSum2=(''+dobleDigSum).split('')
            if(mCheckSum2.length>1){
                let dobleDigSum2=parseInt(mCheckSum2[0])+parseInt(mCheckSum2[1])
                sform+='='+dobleDigSum2
            }
        }
        finalText+=sform+'\n'
        log.setText(finalText)
    }

    // Nueva función para calcular la numerología de textos/nombres
    function stringToNumerology(str) {
        // Tabla pitagórica estándar
        let mapping = {
            'A':1, 'B':2, 'C':3, 'D':4, 'E':5, 'F':6, 'G':7, 'H':8, 'I':9,
            'J':1, 'K':2, 'L':3, 'M':4, 'N':5, 'Ñ':5, 'O':6, 'P':7, 'Q':8, 'R':9,
            'S':1, 'T':2, 'U':3, 'V':4, 'W':5, 'X':6, 'Y':7, 'Z':8
        }

        let cleanStr = str.toUpperCase()
        let sum = 0
        let breakdown = []
        let valuesList = []

        for (let i = 0; i < cleanStr.length; i++) {
            let char = cleanStr[i]
            if (mapping[char] !== undefined) {
                sum += mapping[char]
                breakdown.push(char + "(" + mapping[char] + ")")
                valuesList.push(mapping[char])
            } else if (/[0-9]/.test(char)) { // Si hay números mezclados en la cadena
                let val = parseInt(char)
                sum += val
                breakdown.push(char + "(" + val + ")")
                valuesList.push(val)
            }
        }

        if (valuesList.length === 0) {
            log.clear()
            log.setText("No se encontraron caracteres alfanuméricos válidos.")
            return
        }

        let resText = "Análisis Numerológico Alfanumérico\n\n"
        resText += "Cadena: " + str + "\n"
        resText += "Desglose: " + breakdown.join(" + ") + "\n"

        let sform = valuesList.join("+") + "=" + sum

        // Reducción pitagórica manteniendo números maestros comunes si se desea (11, 22, 33)
        let currentSum = sum
        while (currentSum > 9 && currentSum !== 11 && currentSum !== 22 && currentSum !== 33) {
            let digits = ('' + currentSum).split('')
            let partialSum = 0
            for (let j = 0; j < digits.length; j++) {
                partialSum += parseInt(digits[j])
            }
            sform += " -> " + digits.join("+") + "=" + partialSum
            currentSum = partialSum
        }

        resText += "Reducción: " + sform + "\n\n"
        resText += "Resultado Final: " + currentSum + ""
        resText=resText.replace(/\+/g, ' + ')

        log.clear()
        log.setText(resText)
    }

    function bigNumToPitNum(num, retMK){
        let s=(''+num).replace('-', '')
        let m0=s.split('')
        let ret=num
        if((ret===13||ret===14||ret===16||ret===19||ret===11||ret===22||ret===33)&&retMK){
            return ret
        }
        ret=0
        for(var i=0;i<m0.length;i++){
            ret+=parseInt(m0[i])
        }
        if((ret===13||ret===14||ret===16||ret===19||ret===11||ret===22||ret===33)&&retMK){
            return ret
        }
        if(ret>9){
            s=(''+ret)
            m0=s.split('')
            ret=0
            for(i=0;i<m0.length;i++){
                ret+=parseInt(m0[i])
            }
        }
        if((ret===13||ret===14||ret===16||ret===19||ret===11||ret===22||ret===33)&&retMK){
            return ret
        }
        return ret
    }

    function load(fecha){
        tiSearch.text=fecha
        r.visible=true
    }

    function toEnter(ctrl){
        if(!tiSearch.focus){
            tiSearch.focus=true
            return
        }
        printNumMision()
    }

    function clear(){}
    function toLeft(ctrl){}
    function toRight(ctrl){}
    function toUp(ctrl){}
    function toDown(ctrl){}
    function toTab(){}

    function toEscape(){
        log.toEscape(false)
        if(tiSearch.focus){
            tiSearch.focus=false
            return
        }
        zsm.getPanel('ModulesManager').loadModule('ModulesLoader', '1.0')
    }

    function isFocus(){
        return false
    }

    function toHelp(){
        let itemHelpExist=zsm.cleanOneDinamicItems("ItemHelp_"+app.j.qmltypeof(r))
        if(!itemHelpExist){
            let text='<h2>Ayuda en Construcción</h2><br><br><b><b>Presionar F1: </b>Para ver u ocultar esta ayuda.'
            let c='import comps.ItemHelp 1.0\n'
            c+='ItemHelp{\n'
            c+='    text:"'+text+'"\n'
            c+='    ctx: "'+zsm.cPanelName+'"\n'
            c+='    objectName: "ItemHelp_'+app.j.qmltypeof(r)+'"\n'
            c+='}\n'
            let comp=Qt.createQmlObject(c, zsm, 'itemhelpcode')
        }
    }

    function getNums(fecha){
        let numKarmico=-1
        let d=''
        let nf=0
        let nf10=false
        let f=fecha
        let m0=f.split('/')
        let m1=m0[0].split('')
        if(m1.length<=0)return [-1, -1, -1]
        let m2=m0[1].split('')
        let m3=m0[2].split('')
        nf+=parseInt(m1[0])
        if(m1.length>1){
            nf+=parseInt(m1[1])
        }
        nf+=parseInt(m2[0])
        if(m2.length>1){
            nf+=parseInt(m2[1])
        }
        nf+=parseInt(m3[0])
        if(m3.length>3){
            nf+=parseInt(m3[1])
            nf+=parseInt(m3[2])
            nf+=parseInt(m3[3])
        }
        if(nf===10)nf10=true
        if(nf>9&&(nf===13||nf===14||nf===16||nf===19)){
            numKarmico=nf
        }
        if(nf>9&&nf!==11&&nf!==22&&nf!==33&&nf!==44&&numKarmico<0){
            let m4=(''+nf).split('')
            let nnf=parseInt(m4[0])
            if(m4.length>1){
                nnf+=parseInt(m4[1])
            }
            nf=nnf
        }
        if(nf>9&&(nf===13||nf===14||nf===16||nf===19)){
            numKarmico=nf
        }
        d=''+parseInt(m0[0])
        if(parseInt(m0[0])>9&&numKarmico<0){
            let m5=d.split('')
            let nfd=parseInt(m5[0])
            if(m5.length>1){
                nfd+=parseInt(m5[1])
            }
            d+='-'+nfd
        }
        if(nf===10)nf10=true
        if(nf>9&&numKarmico<0){
            let m6=(''+nf).split('')
            let nnf6=parseInt(m6[0])
            if(m6.length>1){
                nnf6+=parseInt(m6[1])
            }
            nf=nnf6
        }
        let numArbolGen=-1
        if(!nf10){
            if(nf===1||nf===6||nf===8)numArbolGen=0
            if(nf===2||nf===5||nf===9)numArbolGen=1
            if(nf===3||nf===4)numArbolGen=2
            if(nf===7)numArbolGen=3
        }else{
            numArbolGen=2
        }
        return [nf, d, numArbolGen, numKarmico]
    }
}