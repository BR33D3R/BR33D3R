import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  OwnershipTransferred,
  S33DContractCreated,
  SproutContractCreated,
  TrustedContractAdded,
  TrustedContractRemoved
} from "../generated/S01L/S01L"

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}

export function createS33DContractCreatedEvent(
  contractAddress: Address,
  contractId: BigInt
): S33DContractCreated {
  let s33DContractCreatedEvent = changetype<S33DContractCreated>(newMockEvent())

  s33DContractCreatedEvent.parameters = new Array()

  s33DContractCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "contractAddress",
      ethereum.Value.fromAddress(contractAddress)
    )
  )
  s33DContractCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "contractId",
      ethereum.Value.fromUnsignedBigInt(contractId)
    )
  )

  return s33DContractCreatedEvent
}

export function createSproutContractCreatedEvent(
  contractAddress: Address,
  sproutId: BigInt,
  parent: Address
): SproutContractCreated {
  let sproutContractCreatedEvent = changetype<SproutContractCreated>(
    newMockEvent()
  )

  sproutContractCreatedEvent.parameters = new Array()

  sproutContractCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "contractAddress",
      ethereum.Value.fromAddress(contractAddress)
    )
  )
  sproutContractCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "sproutId",
      ethereum.Value.fromUnsignedBigInt(sproutId)
    )
  )
  sproutContractCreatedEvent.parameters.push(
    new ethereum.EventParam("parent", ethereum.Value.fromAddress(parent))
  )

  return sproutContractCreatedEvent
}

export function createTrustedContractAddedEvent(
  contractAddress: Address
): TrustedContractAdded {
  let trustedContractAddedEvent = changetype<TrustedContractAdded>(
    newMockEvent()
  )

  trustedContractAddedEvent.parameters = new Array()

  trustedContractAddedEvent.parameters.push(
    new ethereum.EventParam(
      "contractAddress",
      ethereum.Value.fromAddress(contractAddress)
    )
  )

  return trustedContractAddedEvent
}

export function createTrustedContractRemovedEvent(
  contractAddress: Address
): TrustedContractRemoved {
  let trustedContractRemovedEvent = changetype<TrustedContractRemoved>(
    newMockEvent()
  )

  trustedContractRemovedEvent.parameters = new Array()

  trustedContractRemovedEvent.parameters.push(
    new ethereum.EventParam(
      "contractAddress",
      ethereum.Value.fromAddress(contractAddress)
    )
  )

  return trustedContractRemovedEvent
}
