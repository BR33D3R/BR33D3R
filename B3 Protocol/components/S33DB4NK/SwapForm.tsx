import React from "react";

const SwapForm: React.FC = () => {
  const handleChange = () => {};

  return (
    <div style={{ border: "1px solid black", padding: "16px", minWidth: "275px" }}>
      <h2>Swap</h2>
      <input type="text" placeholder="From NFT Address" onChange={handleChange} />
      <input type="text" placeholder="From Token ID" onChange={handleChange} />
      <input type="text" placeholder="To NFT Address" onChange={handleChange} />
      <input type="text" placeholder="To Token ID" onChange={handleChange} />
      <button style={{ backgroundColor: "blue", color: "white", padding: "8px 16px", margin: "8px" }}>InitiateSwap</button>
      <button style={{ backgroundColor: "red", color: "white", padding: "8px 16px", margin: "8px" }}>CreatePool</button>
      <button style={{ backgroundColor: "grey", color: "white", padding: "8px 16px", margin: "8px" }}>ExecuteSwap</button>
    </div>
  );
};

export default SwapForm;