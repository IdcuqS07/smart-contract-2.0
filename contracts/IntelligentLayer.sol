// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IntelligentLayer
 * @dev Lapisan cerdas yang menghubungkan AI engine dengan blockchain
 * Desain modular untuk berbagai jenis model AI
 */
contract IntelligentLayer {
    
    enum ModelType { PRICE_PREDICTION, RISK_ANALYSIS, FRAUD_DETECTION, SENTIMENT_ANALYSIS }
    
    struct AIModel {
        string name;
        ModelType modelType;
        address provider;
        bool isActive;
        uint256 totalPredictions;
        uint256 averageConfidence;
    }
    
    struct ModelResult {
        uint256 modelId;
        bytes32 resultHash;
        uint256 timestamp;
        uint8 confidence;
    }
    
    mapping(uint256 => AIModel) public models;
    mapping(uint256 => ModelResult[]) public modelResults;
    mapping(address => bool) public authorizedProviders;
    
    uint256 public modelCounter;
    
    event ModelRegistered(uint256 indexed modelId, string name, ModelType modelType);
    event ResultSubmitted(uint256 indexed modelId, bytes32 resultHash, uint8 confidence);
    event ProviderAuthorized(address provider);
    
    /**
     * @dev Register model AI baru
     */
    function registerModel(
        string memory _name,
        ModelType _modelType
    ) external returns (uint256) {
        require(authorizedProviders[msg.sender], "Not authorized provider");
        
        modelCounter++;
        models[modelCounter] = AIModel({
            name: _name,
            modelType: _modelType,
            provider: msg.sender,
            isActive: true,
            totalPredictions: 0,
            averageConfidence: 0
        });
        
        emit ModelRegistered(modelCounter, _name, _modelType);
        return modelCounter;
    }
    
    /**
     * @dev Submit hasil dari AI model
     */
    function submitResult(
        uint256 _modelId,
        bytes32 _resultHash,
        uint8 _confidence
    ) external {
        require(models[_modelId].isActive, "Model not active");
        require(models[_modelId].provider == msg.sender, "Not model provider");
        require(_confidence <= 100, "Invalid confidence");
        
        ModelResult memory result = ModelResult({
            modelId: _modelId,
            resultHash: _resultHash,
            timestamp: block.timestamp,
            confidence: _confidence
        });
        
        modelResults[_modelId].push(result);
        
        // Update statistics
        AIModel storage model = models[_modelId];
        model.totalPredictions++;
        model.averageConfidence = (model.averageConfidence * (model.totalPredictions - 1) + _confidence) / model.totalPredictions;
        
        emit ResultSubmitted(_modelId, _resultHash, _confidence);
    }
    
    /**
     * @dev Authorize provider untuk register model
     */
    function authorizeProvider(address _provider) external {
        authorizedProviders[_provider] = true;
        emit ProviderAuthorized(_provider);
    }
    
    /**
     * @dev Get model info
     */
    function getModelInfo(uint256 _modelId) external view returns (AIModel memory) {
        return models[_modelId];
    }
}
