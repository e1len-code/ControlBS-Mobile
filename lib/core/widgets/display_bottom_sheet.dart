import 'dart:convert';
import 'dart:typed_data';
import 'package:controlbs_mobile/features/file/domain/entities/file.dart';

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

Future displaySignatureModal(
    BuildContext context, FileProvider fileProvider, int persIden) {
  return showModalBottomSheet(
      context: context,
      //isDismissible: false,
      enableDrag: false,
      // isScrollControlled: true,
      builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Puede realizar su firma  en el espacio blanco:"),
                Center(
                  child: AspectRatio(
                    aspectRatio: 2.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          constraints: const BoxConstraints.expand(),
                          color: Colors.white,
                          child: HandSignature(
                            control: control,
                            type: SignatureDrawType.shape,
                            // supportedDevices: {
                            //   PointerDeviceKind.stylus,
                            // },
                          ),
                        ),
                        CustomPaint(
                          painter: DebugSignaturePainterCP(
                            control: control,
                            cp: false,
                            cpStart: false,
                            cpEnd: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: hspaceM,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        control.clear();
                        //Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onError),
                      child: const Text(
                        'LIMPIAR',
                        //style: TextStyle(color: Colors.white)
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        ByteData? signature = await control.toImage(
                            color: const Color.fromARGB(255, 6, 45, 113),
                            background: Colors.white,
                            fit: false);
                        if (signature != null) {
                          String base64 =
                              base64Encode(signature.buffer.asUint8List());
                          fileProvider.save(File(
                              fileiden: 0,
                              filename: persIden.toString(),
                              filetype: 'png',
                              filepath: '',
                              fileba64: base64));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      child: const Text(
                        'GUARDAR FIRMA',
                        //style: TextStyle(color: Colors.white)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
}
