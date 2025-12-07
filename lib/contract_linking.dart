import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  // URL RPC : Web (Chrome) vs Android Emulator
  final String _rpcUrl =
      kIsWeb ? "http://127.0.0.1:7545" : "http://10.0.2.2:7545";
  final String _wsUrl =
      kIsWeb ? "ws://127.0.0.1:7545/" : "ws://10.0.2.2:7545/";

  // ⚠ Mets ici la clé privée du compte Ganache qui a déployé le contrat
  final String _privateKey =
      "0x0c916655964da56edb028be9c06c78a4c2c5ed9673f45644578e2d61b86e2d14";

  late Web3Client _client;
  bool isLoading = true;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;

  // pas besoin de late ici, on a déjà une valeur par défaut
  String deployedName = "Unknown";

  ContractLinking() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    if (kIsWeb) {
      // Sur le web : HTTP seulement
      _client = Web3Client(_rpcUrl, Client());
    } else {
      // Sur Android : HTTP + WebSocket
      _client = Web3Client(
        _rpcUrl,
        Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        },
      );
    }

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/HelloWorld.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    final netId = jsonAbi["networks"]?["5777"];
    if (netId == null) {
      throw Exception(
          "Le fichier JSON n'a pas d'entrée pour le réseau 5777. Vérifie HelloWorld.json");
    }
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"),
      _contractAddress,
    );
    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");
    await getName();
  }

  Future<void> getName() async {
    final result = await _client.call(
      contract: _contract,
      function: _yourName,
      params: [],
    );

    // ✅ on initialise name par défaut
    String name = "";

    if (result.isNotEmpty) {
      final value = result[0];

      if (value is String) {
        // Le contrat renvoie déjà une string
        name = value;
      } else if (value is Uint8List) {
        // Le contrat renvoie bytes : on enlève les zéros puis on décode
        final bytes = value.takeWhile((b) => b != 0).toList();
        name = utf8.decode(bytes, allowMalformed: true);
      } else if (value is List<int>) {
        // Même logique que Uint8List
        final bytes = value.takeWhile((b) => b != 0).toList();
        name = utf8.decode(bytes, allowMalformed: true);
      } else {
        // fallback au cas où
        name = value.toString();
      }
    }

    // 👉 si c'est vide : on affiche "Unknown"
    if (name.trim().isEmpty) {
      deployedName = "Unknown";
    } else {
      deployedName = name;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _setName,
        parameters: [nameToSet],
      ),
      // Ganache a généralement chainId = 1337
      chainId: 1337,
    );

    await getName();
  }
}