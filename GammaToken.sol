pragma solidity ^0.6.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract GammaToken is IERC20 {

    string public constant name = "GammaToken";
    string public constant symbol = "GAMMA";
    uint8 public constant decimals = 0;

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ ;
    address admin;

    constructor(uint256 _tsupply) public {
        totalSupply_ = _tsupply;
        balances[msg.sender] = totalSupply_;
        admin = msg.sender;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "Only admin can do this action");
        _;
    }
    function mint(uint256 _qty) public onlyAdmin returns(uint256) {
        totalSupply_ += _qty;
        balances[msg.sender] += _qty;

        return totalSupply_;
    }
    function burn(uint256 _qty) public onlyAdmin returns(uint256) {
        require(balances[msg.sender] >= _qty);
        totalSupply_ -= _qty;
        balances[msg.sender] -= _qty;

        return totalSupply_;
    }
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        uint256 allowance1 = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance1 >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }


}