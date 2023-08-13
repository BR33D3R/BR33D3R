import React from "react";
import { useQuery } from "@apollo/client";
import gql from "graphql-tag";


  // Polls every 5 seconds


const GET_CONTRACT_DATA = gql`
  query s33dmade {
    sproutContractCreated(id: "") {
      parent
      sproutId
      contractAddress
      blockNumber
      transactionHash
    }
    s33DcontractCreateds(orderBy: id) {
      contractAddress
      contractId
      blockNumber
      transactionHash
    }
  }
`;

export const S01LInfoCard = () => {
  const { loading, error, data } = useQuery(GET_CONTRACT_DATA);
  pollInterval: 5000;

  if (loading) return <div className="p-4">Loading...</div>;
  if (error) return <div className="text-red-500 p-4">Error: {error.message}</div>;
  return (
    <div className="card bordered">
      <div className="card-body">
        <div className="flex justify-center items-center flex-wrap my-4">
        <img src="/favicon.png" alt="Logo 1" className="mx-2 my-2" style={{ width: 180, height: 180 }} />
          <img src="/graph.svg" alt="Logo 1" className="mx-2 my-2" style={{ width: 150, height: 150 }} />
          <img src="/chainlink.svg" alt="Logo 2" className="mx-2 my-2" style={{ width: 150, height: 150 }} />
          <img src="/optimism.svg" alt="Logo 3" className="mx-2 my-2" style={{ width: 150, height: 150 }} />
          <img src="ethereum.svg" alt="Logo 4" className="mx-2 my-2" style={{ width: 150, height: 150 }} />
          <img src="scaffold.svg" alt="Logo 4" className="mx-2 my-2" style={{ width: 150, height: 150 }} />
        </div>

        <h2 className="card-title align-center">Smart Contract data brought to you by</h2>

        <h3 className="text-center my-4">S33D Contracts Created</h3>
        {data?.s33DcontractCreateds.map((contract, index) => (
          <div key={index} className="card my-4">
            <div className="card-body text-center">
              <p>
                <strong>Contract Address:</strong>{" "}
                <a
                  href={`https://goerli-optimism.etherscan.io/address/${contract.contractAddress}`}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  {`${contract.contractAddress.slice(0, 6)}...${contract.contractAddress.slice(-4)}`}
                </a>
              </p>
              {/* Adjust other data points similarly if needed */}
              <p>
                <strong>Transaction Hash:</strong>{" "}
                <a
                  href={`https://goerli-optimism.etherscan.io/tx/${contract.transactionHash}`}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  {`${contract.transactionHash.slice(0, 6)}...${contract.transactionHash.slice(-4)}`}
                </a>
              </p>
            </div>
          </div>
        ))}
        <h3 className="text-center my-4">Sprout Contracts Created</h3>
        {data?.sproutContractCreated && (
          <div className="card my-4">
            <div className="card-body text-center">
              <p>
                <strong>Parent:</strong> {data.sproutContractCreated.parent}
              </p>
              <p>
                <strong>Sprout ID:</strong> {data.sproutContractCreated.sproutId}
              </p>
              <p>
                <strong>Contract Address:</strong>{" "}
                {`${data.sproutContractCreated.contractAddress.slice(
                  0,
                  6,
                )}...${data.sproutContractCreated.contractAddress.slice(-4)}`}
              </p>
              <p>
                <strong>Block Number:</strong> {data.sproutContractCreated.blockNumber}
              </p>
              <p>
                <strong>Transaction Hash:</strong>{" "}
                {`${data.sproutContractCreated.transactionHash.slice(
                  0,
                  6,
                )}...${data.sproutContractCreated.transactionHash.slice(-4)}`}
              </p>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
