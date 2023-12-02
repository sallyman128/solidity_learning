// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

contract Twitter {

    uint16 MAX_TWEET_LENGTH = 280;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) tweets;
    address owner;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount );
    event TweetUnliked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function getTotalLikes(address _author) external view returns(uint) {
        uint totalLikes;

        for (uint i=0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }

        return totalLikes;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long.");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address _author, uint256 _id) external {
        require(tweets[_author][_id].id == _id, "Tweet does not exist");

        tweets[_author][_id].likes++;

        emit TweetLiked(msg.sender, _author, _id, tweets[_author][_id].likes);
    }

    function unlikeTweet(address _author, uint256 _id) external {
        require(tweets[_author][_id].id == _id, "Tweet does not exist");
        require(tweets[_author][_id].likes > 0, "Tweet doesn't have any likes");

        tweets[_author][_id].likes--;

        emit TweetUnliked(msg.sender, _author, _id, tweets[_author][_id].likes);
    }

    function getTweet(uint _i) public view returns(string memory) {
        return tweets[msg.sender][_i].content;
    }

    function getAllTweets() public view returns(Tweet[] memory) {
        return tweets[msg.sender];
    }
}