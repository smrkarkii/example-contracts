//SPDX-License-Identifier:MIT
pragma solidity ^0.6.4;

contract cityPoll {
    
    struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }


    mapping(uint256 => City) public cities; //mapping city Id with the City ctruct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    address owner;
    uint256 public cityCount = 0; // number of city added
    constructor() public {
    
    //TODO set contract caller as owner
    //TODO set some intitial cities.
    owner = msg.sender;
    cities[0].cityName = "Ilam";
    cities[1].cityName = "Kathmandu";
    cities[2].cityName = "Bhaktapur";
    cityCount = 3;
    
    

    }
 
 
    function addCity(uint256 cityId, string memory name) public {
      //  TODO: add city to the CityStruct
        cities[cityId].cityName = name;
        cityCount++;
    }
    
    function vote(uint256 cityId) public {
        
        //TODO Vote the selected city through cityID
        require(!hasVoted[msg.sender], "Already voted");
        cities[cityId].vote++;
        hasVoted[msg.sender] = true;
        }

    function getCity(uint cityId) public view returns (string memory) {
     // TODO get the city details through cityID
     return cities[cityId].cityName;

    }
    function getVote(uint cityId) public view returns (uint256) {
    // TODO get the vote of the city with its ID
    return cities[cityId].vote;
    }
}
