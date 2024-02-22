part of tinkoff_sdk_models;

class AgentData {
  static const _agentSign = 'agentSign';
  static const _operationName = 'operationName';
  static const _phones = 'phones';
  static const _receiverPhones = 'receiverPhones';
  static const _transferPhones = 'transferPhones';
  static const _operatorName = 'operatorName';
  static const _operatorAddress = 'operatorAddress';
  static const _operatorInn = 'operatorInn';

  final AgentSign? agentSign;
  final String? operationName;
  final List<String>? phones;
  final List<String>? receiverPhones;
  final List<String>? transferPhones;
  final String? operatorName;
  final String? operatorAddress;
  final String? operatorInn;

  AgentData({
    this.agentSign,
    this.operationName,
    this.phones,
    this.receiverPhones,
    this.transferPhones,
    this.operatorName,
    this.operatorAddress,
    this.operatorInn,
  });

  Map<String, dynamic> get arguments => {
        _agentSign: agentSign?.name,
        _operationName: operationName,
        _phones: phones,
        _receiverPhones: receiverPhones,
        _transferPhones: transferPhones,
        _operatorName: operatorName,
        _operatorAddress: operatorAddress,
        _operatorInn: operatorInn,
      };
}

enum AgentSign {
  bankPayingAgent(name: 'bankPayingAgent'),
  bankPayingSubagent(name: 'bankPayingSubagent'),
  payingAgent(name: 'payingAgent'),
  payingSubagent(name: 'payingSubagent'),
  attorney(name: 'attorney'),
  commissionAgent(name: 'commissionAgent'),
  another(name: 'another');

  final String name;

  const AgentSign({required this.name});
}
