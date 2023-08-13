import {
  OwnershipTransferred as OwnershipTransferredEvent,
  S33DContractCreated as S33DContractCreatedEvent,
  SproutContractCreated as SproutContractCreatedEvent,
  TrustedContractAdded as TrustedContractAddedEvent,
  TrustedContractRemoved as TrustedContractRemovedEvent
} from "../generated/S01L/S01L"
import {
  OwnershipTransferred,
  S33DContractCreated,
  SproutContractCreated,
  TrustedContractAdded,
  TrustedContractRemoved
} from "../generated/schema"

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleS33DContractCreated(
  event: S33DContractCreatedEvent
): void {
  let entity = new S33DContractCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.contractAddress = event.params.contractAddress
  entity.contractId = event.params.contractId

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSproutContractCreated(
  event: SproutContractCreatedEvent
): void {
  let entity = new SproutContractCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.contractAddress = event.params.contractAddress
  entity.sproutId = event.params.sproutId
  entity.parent = event.params.parent

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleTrustedContractAdded(
  event: TrustedContractAddedEvent
): void {
  let entity = new TrustedContractAdded(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.contractAddress = event.params.contractAddress

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleTrustedContractRemoved(
  event: TrustedContractRemovedEvent
): void {
  let entity = new TrustedContractRemoved(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.contractAddress = event.params.contractAddress

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
