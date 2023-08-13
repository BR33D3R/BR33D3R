import React from "react";

const ExchangePoolForm: React.FC = () => {
  return (
    <div style={{ border: "1px solid black", padding: "16px", minWidth: "275px" }}>
      <h2>Exchange Pool</h2>
      <input type="text" placeholder="From" />
      <input type="text" placeholder="To" />
      <button style={{ backgroundColor: "blue", color: "white", padding: "8px 16px", margin: "8px" }}>Swap</button>
    </div>
  );
};

export default ExchangePoolForm;
