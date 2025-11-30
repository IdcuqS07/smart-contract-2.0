// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SmartContract2
 * @dev Smart Contract 2.0 dengan integrasi AI Layer
 * Kontrak ini dapat menerima input dari AI engine melalui oracle
 */
contract SmartContract2 is Ownable {
    
    // Struktur untuk menyimpan prediksi AI
    struct AIPrediction {
        uint256 timestamp;
        string predictionType; // "price", "risk", "fraud"
        int256 value;
        uint8 confidence; // 0-100
        address oracle;
    }
    
    // Struktur untuk kontrak yang adaptif
    struct AdaptiveContract {
        uint256 id;
        address creator;
        string contractType;
        uint256 threshold;
        bool isActive;
        uint256 createdAt;
        uint256 lastUpdated;
    }
    
    // Storage
    mapping(uint256 => AdaptiveContract) public contracts;
    mapping(uint256 => AIPrediction[]) public contractPredictions;
    mapping(address => bool) public authorizedOracles;
    
    uint256 public contractCounter;
    
    // Events
    event ContractCreated(uint256 indexed contractId, address creator, string contractType);
    event PredictionReceived(uint256 indexed contractId, string predictionType, int256 value, uint8 confidence);
    event ContractExecuted(uint256 indexed contractId, string reason);
    event OracleAuthorized(address oracle);
    event OracleRevoked(address oracle);
    
    constructor() Ownable(msg.sender) {
        contractCounter = 0;
    }
    
    /**
     * @dev Authorize oracle untuk mengirim data AI
     */
    function authorizeOracle(address _oracle) external onlyOwner {
        authorizedOracles[_oracle] = true;
        emit OracleAuthorized(_oracle);
    }
    
    /**
     * @dev Revoke oracle authorization
     */
    function revokeOracle(address _oracle) external onlyOwner {
        authorizedOracles[_oracle] = false;
        emit OracleRevoked(_oracle);
    }
    
    /**
     * @dev Membuat kontrak adaptif baru
     */
    function createAdaptiveContract(
        string memory _contractType,
        uint256 _threshold
    ) external returns (uint256) {
        contractCounter++;
        
        contracts[contractCounter] = AdaptiveContract({
            id: contractCounter,
            creator: msg.sender,
            contractType: _contractType,
            threshold: _threshold,
            isActive: true,
            createdAt: block.timestamp,
            lastUpdated: block.timestamp
        });
        
        emit ContractCreated(contractCounter, msg.sender, _contractType);
        return contractCounter;
    }
    
    /**
     * @dev Oracle mengirim prediksi AI ke kontrak
     */
    function submitAIPrediction(
        uint256 _contractId,
        string memory _predictionType,
        int256 _value,
        uint8 _confidence
    ) external {
        require(authorizedOracles[msg.sender], "Not authorized oracle");
        require(contracts[_contractId].isActive, "Contract not active");
        require(_confidence <= 100, "Invalid confidence value");
        
        AIPrediction memory prediction = AIPrediction({
            timestamp: block.timestamp,
            predictionType: _predictionType,
            value: _value,
            confidence: _confidence,
            oracle: msg.sender
        });
        
        contractPredictions[_contractId].push(prediction);
        contracts[_contractId].lastUpdated = block.timestamp;
        
        emit PredictionReceived(_contractId, _predictionType, _value, _confidence);
        
        // Auto-execute jika threshold tercapai
        _checkAndExecute(_contractId, _value);
    }
    
    /**
     * @dev Cek apakah kontrak perlu dieksekusi berdasarkan AI prediction
     */
    function _checkAndExecute(uint256 _contractId, int256 _value) internal {
        AdaptiveContract storage adaptiveContract = contracts[_contractId];
        
        if (adaptiveContract.isActive && uint256(_value) >= adaptiveContract.threshold) {
            adaptiveContract.isActive = false;
            emit ContractExecuted(_contractId, "Threshold reached based on AI prediction");
        }
    }
    
    /**
     * @dev Get latest prediction untuk kontrak
     */
    function getLatestPrediction(uint256 _contractId) 
        external 
        view 
        returns (AIPrediction memory) 
    {
        require(contractPredictions[_contractId].length > 0, "No predictions");
        return contractPredictions[_contractId][contractPredictions[_contractId].length - 1];
    }
    
    /**
     * @dev Get jumlah prediksi untuk kontrak
     */
    function getPredictionCount(uint256 _contractId) external view returns (uint256) {
        return contractPredictions[_contractId].length;
    }
}
