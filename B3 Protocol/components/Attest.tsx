import { useState } from "react";
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";
import { EAS, SchemaEncoder, SchemaRegistry } from "@ethereum-attestation-service/eas-sdk";
import {useProvider, useSigner} from "../utils/eas-wagmi-utils"

export const EASContractAddress = "0xC2679fBD37d54388Ce493F1DB75320D236e1815e"; // Sepolia v0.26
const eas = new EAS(EASContractAddress);

const signer = useSigner();
eas.connect(signer);

const signer = useProvider();
eas.connect(provider);

// Initialize SchemaEncoder with the schema string
const schemaEncoder = new SchemaEncoder("string genus, string species, string variety, string proof_of_life");
const encodedData = schemaEncoder.encodeData([
  { name: "genus", value: "", type: "string" },
  { name: "species", value: "", type: "string" },
  { name: "variety", value: "", type: "string" },
  { name: "proof_of_life", value: "", type: "string" },
]);

const schemaUID = "0xb16fa048b0d597f5a821747eba64efa4762ee5143e9a80600d0005386edfc995";

const tx = await eas.attest({
  schema: schemaUID,
  data: {
    recipient: "",
    expirationTime: 0,
    revocable: true,
    data: encodedData,
  },
});

const newAttestationUID = await tx.wait();

console.log("New attestation UID:", newAttestationUID);

const uid = "0xff08bbf3d3e6e0992fc70ab9b9370416be59e87897c3d42b20549901d2cccc3e";

const attestation = await eas.getAttestation(uid);

console.log(attestation);