pragma solidity ^0.4.11;

contract voteContract {

    mapping (address => bool) voters; // 하나의 계정 당 한 번의 투표만 가능
    mapping (string => uint) candidates; // 후보자의 득표수를 저장
    mapping (uint8 => string) candidateList; // 후보자의 리스트

    uint8 numberOfCandidates; // 총 후보자 수 
    address contractOwner;

    function voteContract() {
        // 컨트랙트를 생성한 사람을 contractOwner로 저장
        contractOwner = msg.sender;
    }

    // 후보자를 추가하는 함수
    function addCandidate(string cand) {
        bool add = true;
        for (uint8 i = 0; i < numberOfCandidates; i++) {
        
            // 문자열 비교는 해쉬함수(sha3)를 통해서 할 수 있다.
            // 솔리디티에는 문자열 비교에 대한 특별한 함수가 없다.
            if (sha3(candidateList[i]) == sha3(cand)) {
                add = false; break;
            }
        }

        if (add) {
            candidateList[numberOfCandidates] = cand;
            numberOfCandidates++;
        }
    }

    // 투표를 하는 함수
    function vote(string cand) {
        // 하나의 계정은 한번의 투표만 결과에 반영
        if (voters[msg.sender]) { }
        else {
            voters[msg.sender] = true;
            candidates[cand]++;
        }
    }

    // 이미 투표했는지 체크
    function alreadyVoted() constant returns(bool) {
        if (voters[msg.sender])
            return true;
        else
            return false;
    }

    // 후보자의 수를 Return
    function getNumOfCandidates() constant returns(uint8) {
        return numberOfCandidates;
    }

    // 번호에 해당하는 후보의 이름을 Return
    function getCandidateString(uint8 number) constant returns(string) {
        return candidateList[number];
    }

    // 후보의 득표수를 Return
    function getScore(string cand) constant returns(uint) {
        return candidates[cand];
    }

    // 컨트랙트를 삭제
    function killContract() {
        if (contractOwner == msg.sender)
            selfdestruct(contractOwner);
    }
}