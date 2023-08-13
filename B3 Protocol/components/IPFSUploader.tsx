import { create } from "ipfs-http-client";

const ipfs = create({
  host: "ipfs.infura.io",
  port: 5001,
  protocol: "https",
  headers: {
    authorization: `Bearer ${process.env.NEXT_PUBLIC_INFURA_API_KEY}`
  }
});

async function uploadToIPFS(buffer: Buffer): Promise<string> {
  const result = await ipfs.add(buffer);
  return result.path;
}

export async function createNFTMetadata(imageBuffer: Buffer, name: string, description: string): Promise<string> {
  const imageCID = await uploadToIPFS(imageBuffer);
  const imageUrl = `ipfs://${imageCID}`;

  const metadata = {
    name: name,
    description: description,
    image: imageUrl,
    // ... any other metadata fields you need
  };

  const metadataBuffer = Buffer.from(JSON.stringify(metadata));
  const metadataCID = await uploadToIPFS(metadataBuffer);

  return `ipfs://${metadataCID}`;
}

export default createNFTMetadata;
