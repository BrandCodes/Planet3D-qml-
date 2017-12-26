/****************************************************************************
**
** Copyright (C) 2014 Klaralvdalens Datakonsult AB (KDAB).
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

uniform highp mat4 viewMatrix;

uniform highp vec3 lightPosition;
uniform highp vec3 lightIntensity;

uniform highp vec3 ka;            // Reflectancia Ambiental
uniform highp vec3 ks;            // Reflectancia Epecular
uniform highp float shininess;    // Factor de brillo Especular
uniform highp float opacity;      // Canal Alpha

uniform sampler2D diffuseTexture;
uniform sampler2D normalTexture;

varying highp vec4 positionInLightSpace;

varying highp vec3 lightDir;
varying highp vec3 viewDir;
varying highp vec2 texCoord;

highp vec3 dbModel(const highp vec3 norm, const highp vec2 flipYTexCoord)
{
    // Reflexión  de la dirección de luz  sobre la normal
    highp vec3 r = reflect(-lightDir, norm);

    highp vec3 diffuseColor = texture2D(diffuseTexture, flipYTexCoord).rgb;

    // Calcula la contribución del ambiente
    highp vec3 ambient = lightIntensity * ka * diffuseColor;

    // Calcula la contribución difusa
    highp float sDotN = max(dot(lightDir, norm), 0.0);
    highp vec3 diffuse = lightIntensity * diffuseColor * sDotN;

    // Calcula la contribución del resaltado especular.
    highp vec3 specular = vec3(0.0);
    if (sDotN > 0.0)
        specular = (lightIntensity * ks) * pow(max(dot(r, viewDir), 0.0), shininess);

    return ambient + diffuse + specular;
}

void main()
{
    highp vec2 flipYTexCoord = texCoord;
    flipYTexCoord.y = 1.0 - texCoord.y;

    highp vec4 normal = 2.0 * texture2D(normalTexture, flipYTexCoord) - vec4(1.0);

    highp vec3 result = dbModel(normalize(normal.xyz), flipYTexCoord);

    gl_FragColor = vec4(result, opacity);
}
