// THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.

import {
  ethereum,
  JSONValue,
  TypedMap,
  Entity,
  Bytes,
  Address,
  BigInt
} from "@graphprotocol/graph-ts";

export class OwnershipTransferred extends ethereum.Event {
  get params(): OwnershipTransferred__Params {
    return new OwnershipTransferred__Params(this);
  }
}

export class OwnershipTransferred__Params {
  _event: OwnershipTransferred;

  constructor(event: OwnershipTransferred) {
    this._event = event;
  }

  get previousOwner(): Address {
    return this._event.parameters[0].value.toAddress();
  }

  get newOwner(): Address {
    return this._event.parameters[1].value.toAddress();
  }
}

export class S33DContractCreated extends ethereum.Event {
  get params(): S33DContractCreated__Params {
    return new S33DContractCreated__Params(this);
  }
}

export class S33DContractCreated__Params {
  _event: S33DContractCreated;

  constructor(event: S33DContractCreated) {
    this._event = event;
  }

  get contractAddress(): Address {
    return this._event.parameters[0].value.toAddress();
  }

  get contractId(): BigInt {
    return this._event.parameters[1].value.toBigInt();
  }
}

export class SproutContractCreated extends ethereum.Event {
  get params(): SproutContractCreated__Params {
    return new SproutContractCreated__Params(this);
  }
}

export class SproutContractCreated__Params {
  _event: SproutContractCreated;

  constructor(event: SproutContractCreated) {
    this._event = event;
  }

  get contractAddress(): Address {
    return this._event.parameters[0].value.toAddress();
  }

  get sproutId(): BigInt {
    return this._event.parameters[1].value.toBigInt();
  }

  get parent(): Address {
    return this._event.parameters[2].value.toAddress();
  }
}

export class TrustedContractAdded extends ethereum.Event {
  get params(): TrustedContractAdded__Params {
    return new TrustedContractAdded__Params(this);
  }
}

export class TrustedContractAdded__Params {
  _event: TrustedContractAdded;

  constructor(event: TrustedContractAdded) {
    this._event = event;
  }

  get contractAddress(): Address {
    return this._event.parameters[0].value.toAddress();
  }
}

export class TrustedContractRemoved extends ethereum.Event {
  get params(): TrustedContractRemoved__Params {
    return new TrustedContractRemoved__Params(this);
  }
}

export class TrustedContractRemoved__Params {
  _event: TrustedContractRemoved;

  constructor(event: TrustedContractRemoved) {
    this._event = event;
  }

  get contractAddress(): Address {
    return this._event.parameters[0].value.toAddress();
  }
}

export class S01L extends ethereum.SmartContract {
  static bind(address: Address): S01L {
    return new S01L("S01L", address);
  }

  cost(): BigInt {
    let result = super.call("cost", "cost():(uint256)", []);

    return result[0].toBigInt();
  }

  try_cost(): ethereum.CallResult<BigInt> {
    let result = super.tryCall("cost", "cost():(uint256)", []);
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBigInt());
  }

  createSprout(newOwner: Address): Address {
    let result = super.call("createSprout", "createSprout(address):(address)", [
      ethereum.Value.fromAddress(newOwner)
    ]);

    return result[0].toAddress();
  }

  try_createSprout(newOwner: Address): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "createSprout",
      "createSprout(address):(address)",
      [ethereum.Value.fromAddress(newOwner)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  getLastS33DContract(): Address {
    let result = super.call(
      "getLastS33DContract",
      "getLastS33DContract():(address)",
      []
    );

    return result[0].toAddress();
  }

  try_getLastS33DContract(): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "getLastS33DContract",
      "getLastS33DContract():(address)",
      []
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  getLastS33DContractId(): BigInt {
    let result = super.call(
      "getLastS33DContractId",
      "getLastS33DContractId():(uint256)",
      []
    );

    return result[0].toBigInt();
  }

  try_getLastS33DContractId(): ethereum.CallResult<BigInt> {
    let result = super.tryCall(
      "getLastS33DContractId",
      "getLastS33DContractId():(uint256)",
      []
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBigInt());
  }

  getLastSproutContract(): Address {
    let result = super.call(
      "getLastSproutContract",
      "getLastSproutContract():(address)",
      []
    );

    return result[0].toAddress();
  }

  try_getLastSproutContract(): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "getLastSproutContract",
      "getLastSproutContract():(address)",
      []
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  getLastSproutId(): BigInt {
    let result = super.call(
      "getLastSproutId",
      "getLastSproutId():(uint256)",
      []
    );

    return result[0].toBigInt();
  }

  try_getLastSproutId(): ethereum.CallResult<BigInt> {
    let result = super.tryCall(
      "getLastSproutId",
      "getLastSproutId():(uint256)",
      []
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBigInt());
  }

  getS33DContract(contractId: BigInt): Address {
    let result = super.call(
      "getS33DContract",
      "getS33DContract(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(contractId)]
    );

    return result[0].toAddress();
  }

  try_getS33DContract(contractId: BigInt): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "getS33DContract",
      "getS33DContract(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(contractId)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  getSproutContract(contractId: BigInt): Address {
    let result = super.call(
      "getSproutContract",
      "getSproutContract(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(contractId)]
    );

    return result[0].toAddress();
  }

  try_getSproutContract(contractId: BigInt): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "getSproutContract",
      "getSproutContract(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(contractId)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  isValidS33DContract(_contract: Address): boolean {
    let result = super.call(
      "isValidS33DContract",
      "isValidS33DContract(address):(bool)",
      [ethereum.Value.fromAddress(_contract)]
    );

    return result[0].toBoolean();
  }

  try_isValidS33DContract(_contract: Address): ethereum.CallResult<boolean> {
    let result = super.tryCall(
      "isValidS33DContract",
      "isValidS33DContract(address):(bool)",
      [ethereum.Value.fromAddress(_contract)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBoolean());
  }

  owner(): Address {
    let result = super.call("owner", "owner():(address)", []);

    return result[0].toAddress();
  }

  try_owner(): ethereum.CallResult<Address> {
    let result = super.tryCall("owner", "owner():(address)", []);
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  parentChildRelationship(param0: Address): Address {
    let result = super.call(
      "parentChildRelationship",
      "parentChildRelationship(address):(address)",
      [ethereum.Value.fromAddress(param0)]
    );

    return result[0].toAddress();
  }

  try_parentChildRelationship(param0: Address): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "parentChildRelationship",
      "parentChildRelationship(address):(address)",
      [ethereum.Value.fromAddress(param0)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  s33dContracts(param0: BigInt): Address {
    let result = super.call(
      "s33dContracts",
      "s33dContracts(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(param0)]
    );

    return result[0].toAddress();
  }

  try_s33dContracts(param0: BigInt): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "s33dContracts",
      "s33dContracts(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(param0)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  sproutContracts(param0: BigInt): Address {
    let result = super.call(
      "sproutContracts",
      "sproutContracts(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(param0)]
    );

    return result[0].toAddress();
  }

  try_sproutContracts(param0: BigInt): ethereum.CallResult<Address> {
    let result = super.tryCall(
      "sproutContracts",
      "sproutContracts(uint256):(address)",
      [ethereum.Value.fromUnsignedBigInt(param0)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toAddress());
  }

  trustedContracts(param0: Address): boolean {
    let result = super.call(
      "trustedContracts",
      "trustedContracts(address):(bool)",
      [ethereum.Value.fromAddress(param0)]
    );

    return result[0].toBoolean();
  }

  try_trustedContracts(param0: Address): ethereum.CallResult<boolean> {
    let result = super.tryCall(
      "trustedContracts",
      "trustedContracts(address):(bool)",
      [ethereum.Value.fromAddress(param0)]
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBoolean());
  }
}

export class S0WS33DCall extends ethereum.Call {
  get inputs(): S0WS33DCall__Inputs {
    return new S0WS33DCall__Inputs(this);
  }

  get outputs(): S0WS33DCall__Outputs {
    return new S0WS33DCall__Outputs(this);
  }
}

export class S0WS33DCall__Inputs {
  _call: S0WS33DCall;

  constructor(call: S0WS33DCall) {
    this._call = call;
  }

  get seedName(): string {
    return this._call.inputValues[0].value.toString();
  }

  get seedSymbol(): string {
    return this._call.inputValues[1].value.toString();
  }
}

export class S0WS33DCall__Outputs {
  _call: S0WS33DCall;

  constructor(call: S0WS33DCall) {
    this._call = call;
  }

  get value0(): Address {
    return this._call.outputValues[0].value.toAddress();
  }
}

export class CreateSproutCall extends ethereum.Call {
  get inputs(): CreateSproutCall__Inputs {
    return new CreateSproutCall__Inputs(this);
  }

  get outputs(): CreateSproutCall__Outputs {
    return new CreateSproutCall__Outputs(this);
  }
}

export class CreateSproutCall__Inputs {
  _call: CreateSproutCall;

  constructor(call: CreateSproutCall) {
    this._call = call;
  }

  get newOwner(): Address {
    return this._call.inputValues[0].value.toAddress();
  }
}

export class CreateSproutCall__Outputs {
  _call: CreateSproutCall;

  constructor(call: CreateSproutCall) {
    this._call = call;
  }

  get value0(): Address {
    return this._call.outputValues[0].value.toAddress();
  }
}

export class RemoveTrustedContractCall extends ethereum.Call {
  get inputs(): RemoveTrustedContractCall__Inputs {
    return new RemoveTrustedContractCall__Inputs(this);
  }

  get outputs(): RemoveTrustedContractCall__Outputs {
    return new RemoveTrustedContractCall__Outputs(this);
  }
}

export class RemoveTrustedContractCall__Inputs {
  _call: RemoveTrustedContractCall;

  constructor(call: RemoveTrustedContractCall) {
    this._call = call;
  }

  get _contract(): Address {
    return this._call.inputValues[0].value.toAddress();
  }
}

export class RemoveTrustedContractCall__Outputs {
  _call: RemoveTrustedContractCall;

  constructor(call: RemoveTrustedContractCall) {
    this._call = call;
  }
}

export class RenounceOwnershipCall extends ethereum.Call {
  get inputs(): RenounceOwnershipCall__Inputs {
    return new RenounceOwnershipCall__Inputs(this);
  }

  get outputs(): RenounceOwnershipCall__Outputs {
    return new RenounceOwnershipCall__Outputs(this);
  }
}

export class RenounceOwnershipCall__Inputs {
  _call: RenounceOwnershipCall;

  constructor(call: RenounceOwnershipCall) {
    this._call = call;
  }
}

export class RenounceOwnershipCall__Outputs {
  _call: RenounceOwnershipCall;

  constructor(call: RenounceOwnershipCall) {
    this._call = call;
  }
}

export class TransferOwnershipCall extends ethereum.Call {
  get inputs(): TransferOwnershipCall__Inputs {
    return new TransferOwnershipCall__Inputs(this);
  }

  get outputs(): TransferOwnershipCall__Outputs {
    return new TransferOwnershipCall__Outputs(this);
  }
}

export class TransferOwnershipCall__Inputs {
  _call: TransferOwnershipCall;

  constructor(call: TransferOwnershipCall) {
    this._call = call;
  }

  get newOwner(): Address {
    return this._call.inputValues[0].value.toAddress();
  }
}

export class TransferOwnershipCall__Outputs {
  _call: TransferOwnershipCall;

  constructor(call: TransferOwnershipCall) {
    this._call = call;
  }
}
