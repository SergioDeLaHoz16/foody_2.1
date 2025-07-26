import 'package:flutter/material.dart';
import 'package:foody/utils/constants/colors.dart';
import 'package:foody/utils/helpers/helper_functions.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Términos y Condiciones",
          style: TextStyle(
            color: isDark ? CColors.light : CColors.secondaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? CColors.light : CColors.secondaryTextColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Términos y Condiciones de Uso
Fecha de entrada en vigor: [23/05/2025]

Bienvenido(a) a nuestra aplicación. Al acceder o utilizar esta aplicación móvil, aceptas cumplir y quedar legalmente obligado(a) por los siguientes Términos y Condiciones de Uso. Si no estás de acuerdo con alguno de estos términos, por favor, no utilices esta aplicación.

1. Aceptación de los Términos
El uso de esta aplicación implica la aceptación plena y sin reservas de todos los términos incluidos en este documento. Nos reservamos el derecho de modificar estos términos en cualquier momento. Los cambios entrarán en vigor una vez publicados en esta pantalla.

2. Uso Adecuado de la Aplicación
Te comprometes a utilizar esta aplicación únicamente con fines lícitos y de acuerdo con estos términos. Está prohibido:

Utilizar la aplicación de forma que pueda dañarla, sobrecargarla o perjudicar su funcionamiento.

Acceder a datos no destinados a ti o intentar vulnerar la seguridad de la aplicación.

Usar contenido ofensivo, ilegal o difamatorio a través de cualquier funcionalidad.

3. Propiedad Intelectual
Todos los derechos de propiedad intelectual de los contenidos, diseño, imágenes, marcas, logotipos y otros elementos de esta aplicación pertenecen a [Nombre de tu empresa o desarrollador], o cuentan con licencia para su uso. No está permitido copiar, distribuir o reutilizar ninguno de estos elementos sin autorización expresa.

4. Privacidad y Protección de Datos
Tu privacidad es importante para nosotros. Recopilamos y tratamos datos personales de acuerdo con nuestra Política de Privacidad, la cual puedes consultar dentro de la aplicación. Al utilizar esta aplicación, aceptas dicho tratamiento de datos.

5. Limitación de Responsabilidad
Esta aplicación se proporciona "tal cual", sin garantías de ningún tipo. No garantizamos que el servicio sea ininterrumpido, seguro o libre de errores. No nos hacemos responsables de cualquier daño derivado del uso o la imposibilidad de uso de esta aplicación.

6. Enlaces a Terceros
Esta aplicación puede contener enlaces a sitios web o servicios de terceros. No tenemos control sobre ellos y no nos hacemos responsables de su contenido ni de sus prácticas de privacidad.

7. Terminación del Acceso
Podemos suspender o cancelar tu acceso a la aplicación en cualquier momento y sin previo aviso, si violas estos términos o si decidimos descontinuar el servicio.

8. Legislación Aplicable
Estos términos se rigen por las leyes de Colombia, y cualquier disputa derivada del uso de la aplicación será sometida a los tribunales competentes de dicha jurisdicción.''',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _accepted,
                  onChanged: (value) {
                    setState(() {
                      _accepted = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text("He leído y acepto los términos y condiciones."),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  _accepted
                      ? () {
                        // Puedes hacer alguna acción como guardar esta aceptación o volver atrás
                        Navigator.pop(context);
                      }
                      : null,
              child: Text("Aceptar"),
            ),
          ],
        ),
      ),
    );
  }
}
