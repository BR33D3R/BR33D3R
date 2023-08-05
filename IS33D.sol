interface IS33D {
    function initialize(string memory _genus, string memory _species, string memory _variety) external;
    function genus() external view returns (string memory);
    function species() external view returns (string memory);
    function variety() external view returns (string memory);
}
