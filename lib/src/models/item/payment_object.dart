part of tinkoff_sdk_models;

enum PaymentObject105 {
  excise(name: 'excise'),
  job(name: 'job'),
  service(name: 'service'),
  gamblingBet(name: 'gamblingBet'),
  gamblingPrize(name: 'gamblingPrize'),
  lottery(name: 'lottery'),
  lotteryPrize(name: 'lotteryPrize'),
  intellectualActivity(name: 'intellectualActivity'),
  payment(name: 'payment'),
  agentCommission(name: 'agentCommission'),
  composite(name: 'composite'),
  another(name: 'another');

  final String name;

  const PaymentObject105({required this.name});
}

enum PaymentObject12 {
  excise(name: 'excise'),
  job(name: 'job'),
  service(name: 'service'),
  gamblingBet(name: 'gamblingBet'),
  gamblingPrize(name: 'gamblingPrize'),
  lottery(name: 'lottery'),
  lotteryPrize(name: 'lotteryPrize'),
  intellectualActivity(name: 'intellectualActivity'),
  payment(name: 'payment'),
  agentCommission(name: 'agentCommission'),
  composite(name: 'composite'),
  another(name: 'another'),
  commodity(name: 'commodity'),
  contribution(name: 'contribution'),
  propertyRights(name: 'propertyRights'),
  unrealization(name: 'unrealization'),
  taxReduction(name: 'taxReduction'),
  trade_fee(name: 'trade_fee'),
  resort_tax(name: 'resort_tax'),
  pledge(name: 'pledge'),
  incomeDecrease(name: 'incomeDecrease'),
  iePensionInsuranceWithoutPayments(name: 'iePensionInsuranceWithoutPayments'),
  iePensionInsuranceWithPayments(name: 'iePensionInsuranceWithPayments'),
  ieMedicalInsuranceWithoutPayments(name: 'ieMedicalInsuranceWithoutPayments'),
  ieMedicalInsuranceWithPayments(name: 'ieMedicalInsuranceWithPayments'),
  socialInsurance(name: 'socialInsurance'),
  casinoChips(name: 'casinoChips'),
  agentPayment(name: 'agentPayment'),
  excisableGoodsWithoutMarkingCode(name: 'excisableGoodsWithoutMarkingCode'),
  excisableGoodsWithMarkingCode(name: 'excisableGoodsWithMarkingCode'),
  goodsWithoutMarkingCode(name: 'goodsWithoutMarkingCode'),
  goodsWithMarkingCode(name: 'goodsWithMarkingCode');

  final String name;

  const PaymentObject12({required this.name});
}
