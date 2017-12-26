/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Scene3D 2.0

// Aquí se implementan los botones de selección para los planetas y su hoja de información (elementos 2D, botones, y deslizadores).
Item {
    id: mainview
    width: 1280
    height: 768
    visible: true
    property int focusedPlanet: 3
    property int oldPlanet: 0
    property int frames: 0
    property int sliderLength: (width < height) ? width / 2 : height / 2
    property real textSize: sliderLength / 20
    property real planetButtonSize: (height < 2200) ? (height / 11) : 200
    property real distanceFactor: 2

    //! [0] --| Renderiza el tipo 3D con "Scene3D"
    Scene3D {
        anchors.fill: parent
        aspects: ["render", "logic", "input"]
        focus: true

        SolarSystem { id: solarsystem }
    }    //! [0]

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        property bool girar: false
        function startRotation(){               //\\ésta función ayuda para el giro al dar click
            if (girar){
                solarsystem.changeSpeed(0.1)
            }
            else{
                solarsystem.changeSpeed(0.0)
            }
        }
        /*onClicked:    {
            if (clicked)
                if (!girar){
                    girar = !girar;
                    //solarsystem.changeSpeed(0.1)
                    startRotation()
                }
                else{
                    girar=false
                    //solarsystem.changeSpeed(0.0)
                    startRotation()
                }
        }*/
        onWheel: {
            if(wheel.angleDelta.y>0){
                //if(solarsystem.cameraDistance == 1 && solarsystem.cameraDistance <=3)
                    solarsystem.cameraDistance += 0.01
                    //solarsystem.changeCameraDistance(2)
                    //mainview.distanceFactor += 0.1;
            }
            else{
                solarsystem.cameraDistance -= 0.01
                //solarsystem.changeCameraDistance(1)        //ChangeCamra distance queda inservible almenos en ésta parte
                //mainview.distanceFactor -= 0.1;
            }
        }

        /*Timer {
              id: secuencia
              interval: 1000;  running: false; repeat: false
              onTriggered:  {
                  if(clicked){
                      secuencia.running=true
                      solarsystem.changeSpeed(0.1)
                  }
                  else
                      secuencia.running=false
                      solarsystem.changeSpeed(0.0)
              }
        }*/
        //--|Ésta parte de puede quitar para omitir el desfase de la Tierra hacia la vista del SistemaSolar al hacer click fuera del planeta.
//        onClicked:
//            focusedPlanet = 3
            //focusedPlanet = 100
    }//Fin MouseArea

    //! [1] --| Botónes de selección: Los botones de selección con la propiedad "focusedPlanet" se cambian de apariencia en la vista principal.
    // A medida que la propiedad cambia la infromación del planeta se actualiza y la cámara se anima a la nueva posición.
    onFocusedPlanetChanged: {
        if (focusedPlanet == 100) {
            info.opacity = 0
            updatePlanetInfo()
        } else {
            updatePlanetInfo()
            info.opacity = 0.5
        }

        solarsystem.changePlanetFocus(oldPlanet, focusedPlanet) //--La posición de la cámara y el aspecto en el punto se actualizan desde "Solarsystem" desencadenandoce de la función "changePlanetFocus();"
        oldPlanet = focusedPlanet
    }//! [1]

    // Dentro de éste ListModel se guarda toda la info de los Planetas (para fácil manejo).
    ListModel {
        id: planetModel

        ListElement {
            name: "Sol"
            radius: "109 x Earth"
            temperature: "5 778 K"
            orbitalPeriod: ""
            distance: ""
            planetImageSource: "qrc:/images/sun.png"
            planetNumber: 0
        }
        ListElement {
            name: "Mercury"
            radius: "0.3829 x Earth"
            temperature: "80-700 K"
            orbitalPeriod: "87.969 d"
            distance: "0.387 098 AU"
            planetImageSource: "qrc:/images/mercury.png"
            planetNumber: 1
        }
        ListElement {
            name: "Venus"
            radius: "0.9499 x Earth"
            temperature: "737 K"
            orbitalPeriod: "224.701 d"
            distance: "0.723 327 AU"
            planetImageSource: "qrc:/images/venus.png"
            planetNumber: 2
        }
        ListElement {
            name: "Earth"
            //radius: "6 378.1 km"
            radius: "0.3829 x Earth"
            temperature: "184-330 K"
            orbitalPeriod: "365.256 d"
            //distance: "149598261 km (1 AU)"
            distance: "0.387 098 AU"
            planetImageSource: "qrc:/images/earth.png"
            planetNumber: 3
        }
        ListElement {
            name: "Mars"
            radius: "0.533 x Earth"
            temperature: "130-308 K"
            orbitalPeriod: "686.971 d"
            distance: "1.523679 AU"
            planetImageSource: "qrc:/images/mars.png"
            planetNumber: 4
        }
        ListElement {
            name: "Jupiter"
            radius: "11.209 x Earth"
            temperature: "112-165 K"
            orbitalPeriod: "4332.59 d"
            distance: "5.204267 AU"
            planetImageSource: "qrc:/images/jupiter.png"
            planetNumber: 5
        }
        ListElement {
            name: "Saturn"
            radius: "9.4492 x Earth"
            temperature: "84-134 K"
            orbitalPeriod: "10759.22 d"
            distance: "9.5820172 AU"
            planetImageSource: "qrc:/images/saturn.png"
            planetNumber: 6
        }
        ListElement {
            name: "Uranus"
            radius: "4.007 x Earth"
            temperature: "49-76 K"
            orbitalPeriod: "30687.15 d"
            distance: "19.189253 AU"
            planetImageSource: "qrc:/images/uranus.png"
            planetNumber: 7
        }
        ListElement {
            name: "Neptune"
            radius: "3.883 x Earth"
            temperature: "55-72 K"
            orbitalPeriod: "60190.03 d"
            distance: "30.070900 AU"
            planetImageSource: "qrc:/images/neptune.png"
            planetNumber: 8
        }
        ListElement {
            name: "Solar System"
            planetImageSource: ""
            planetNumber: 100 // Defaults to solar system
        }
    }//Fin ListModel

    //Es un componente, el delegado que define como se mostrarán los datos y el ListView es el modelo donde se mostraran los datos.
    //--|PlanetButton|--\\ *[Al parecer son los botones de los planetas (costado derecho)].
    /*Component {
        id: planetButtonDelegate
        PlanetButton {
            source: planetImageSource
            text: name
            focusPlanet: planetNumber
            planetSelector: mainview
            buttonSize: planetButtonSize
            fontSize: textSize
        }
    }
    ListView {
        id: planetButtonView
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: planetButtonSize / 5
        anchors.bottomMargin: planetButtonSize / 7
        spacing: planetButtonSize / 7
        width: planetButtonSize * 1.4
        interactive: false
        model: planetModel
        delegate: planetButtonDelegate
    }*/

    //Es la información que sale al inicio y junto con cada planeta.
    //--|InfoSheet.qml|--\\ ----- al quitarla se modifican los tamaños de los planetas
    /*InfoSheet {
        id: info
        width: 400
        anchors.right: planetButtonView.left
        anchors.rightMargin: 10
        opacity: 0.5

        //Establece la información inicial para SolarSystem
        planet: "Solar System"
        exampleDetails: "Éste ejemplo muestra un modelo 3D del Sistema</p>" +
                        "<p>Solar compuesto ppor el Sol y los ocho</p>" +
                        "<p>planetas que orbitan el Sol.</p></br>" +
                        "<p>El ejemplo está implementado usando Qt3D.</p>" +
                        "<p>Las texturas e imagenes utilizadas en el ejemplo</p>" +
                        "<p>son Copyright (c) por James Hastings-Trew,</p>" +
                        "<a href=\"http://planetpixelemporium.com/planets.html\">" +
                        "http://planetpixelemporium.com/planets.html</a>"
    }*/
    //La función por la cual se ayuda a actualizar la información de cada planeta
    /*function updatePlanetInfo() {
        info.width = 200
        if (focusedPlanet !== 100) {
            info.planet = planetModel.get(focusedPlanet).name
            info.radius = planetModel.get(focusedPlanet).radius
            info.temperature = planetModel.get(focusedPlanet).temperature
            info.orbitalPeriod = planetModel.get(focusedPlanet).orbitalPeriod
            info.distance = planetModel.get(focusedPlanet).distance
        }
    }*/

    //Deslizantes:
    StyledSlider {  //DEslizante de Velocidad (rotación)        //Lo vuelvo a poner para rotar a la tierra sin tomar en cuenta la velocidad.
        id: speedSlider
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: sliderLength
        value: 0.0//0.2
        minimumValue: 0.0
        maximumValue: 0.3      //1

        onValueChanged: solarsystem.changeRotation(value)             //solarsystem.changeSpeed(value)    //solarsystem.animate(solarsystem.returnFocusedPlanet())                  //onValueChanged: solarsystem.changeSpeed(value)
        //onValueChanged: solarsystem.daysPerFrame += 0.1
    }
    Text {
        anchors.right: speedSlider.left
        anchors.verticalCenter: speedSlider.verticalCenter
        anchors.rightMargin: 10
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Rotation"
    }

    StyledSlider {  //DEslizante
        id: scaleSlider
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: sliderLength
        value: 0         //1200
        minimumValue: 1   //1
        maximumValue: 4000
        onValueChanged: solarsystem.changeScale(value, false)
    }
    Text {
        anchors.right: scaleSlider.left
        anchors.verticalCenter: scaleSlider.verticalCenter
        anchors.rightMargin: 10
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Planet Size"
    }

    /*StyledSlider {  //DEslizante de Distancia
        id: distanceSlider
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        orientation: Qt.Vertical
        height: sliderLength
        value: 1
        minimumValue: 1
        maximumValue: 2
        //! [2]
        onValueChanged: solarsystem.changeCameraDistance(value) //--Cambia el valor del control "Visualización de distancia"  desde changeCameraDistance();
        //! [2]
    }
    Text {
        y: distanceSlider.y + distanceSlider.height + width + 10
        x: distanceSlider.x + 30 - textSize
        transform: Rotation {
            origin.x: 0
            origin.y: 0
            angle: -90
        }
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Viewing Distance"
    }*/

    // La pantalla FPS, inicialmente oculta, cliqueando aparecerá
    //--|FpsDisplay.qml|--\\
    /*FpsDisplay {                              //lo comenté y oculta los planetas al hacer click
        id: fpsDisplay
        anchors.left: parent.left
        anchors.top: parent.top
        width: 32
        height: 64
        hidden: true
    }
    Timer {
        interval: 1000
        repeat: true
        running: !fpsDisplay.hidden
        onTriggered: {
            fpsDisplay.fps = frames
            frames = 0
        }
        onRunningChanged: frames = 0
    }*/
}//Fin
