#ifndef TYPES_H
#define TYPES_H
#include <string>
#include <utility>

struct Expression {
	std::string expression_string;
	explicit Expression(std::string  str) : expression_string{std::move(str)} {}
};

struct Literal : Expression {
	explicit Literal(const std::string& str) : Expression{str} {}
};

struct VariableIdentifier : Expression {
    explicit VariableIdentifier(const std::string& str) : Expression{str} {}
};

struct LocationIdentifier : Expression {
	explicit LocationIdentifier(const std::string& str) : Expression{str} {}
};

struct Deadlock : Expression {
	explicit Deadlock(const std::string& str) : Expression{str} {}
};

struct LogicOperator : Expression {
	enum struct OperatorType {
		AND, OR, UNKNOWN
	};
	OperatorType type;
	Expression left, right;
	static OperatorType FromString(const std::string& string) {
        if(string == "&&") return OperatorType::AND;
		if(string == "and")return OperatorType::AND;
		if(string == "||") return OperatorType::OR;
        if(string == "or") return OperatorType::OR;
		return OperatorType::UNKNOWN; // Something is very wrong, my dude
	}
	LogicOperator(const std::string& str, Expression l, Expression r) : Expression{str}, type{FromString(str)}, left{std::move(l)}, right{std::move(r)} {}
};

struct NegationOperator : Expression {
	Expression subExpression;
	explicit NegationOperator(Expression sub) : Expression{"!"}, subExpression{std::move(sub)} {}
};

struct Comparator : Expression {
	enum struct CompareType {
		LESSTHAN, LESSTHANEQUAL, NOTEQUAL, EQUAL, GREATERTHAN, GREATERTHANEQUAL, UNKNOWN
	};
	CompareType type;
	Expression left, right;
	static CompareType FromString(const std::string& string) {
        if(string == "<") return CompareType::LESSTHAN;
        if(string == "<=") return CompareType::LESSTHANEQUAL;
        if(string == "!=") return CompareType::NOTEQUAL;
        if(string == "==") return CompareType::EQUAL;
        if(string == ">=") return CompareType::GREATERTHAN;
        if(string == ">") return CompareType::GREATERTHANEQUAL;
		return CompareType::UNKNOWN; // There is something very wrong, my dude
	}
	Comparator(const std::string& str, Expression l, Expression r) : Expression{str}, type{FromString(str)}, left{std::move(l)}, right{std::move(r)} {}
};

/* LPAREN subexpr RPAREN */
struct SubExpression : Expression {
	Expression expr;
	SubExpression(const std::string& str, Expression e) : Expression{str}, expr{std::move(e)} {}
};

struct Quantifier  {
	Expression expression;
	explicit Quantifier(Expression e) : expression{std::move(e)} {}
};

struct Finally : Quantifier {
	explicit Finally(const Expression& e) : Quantifier{e} {}
};
struct Globally : Quantifier {
	explicit Globally(const Expression& e) : Quantifier{e} {}
};
struct Next : Quantifier {
	explicit Next(const Expression& e) : Quantifier{e} {}
};
struct Until : Quantifier {
	explicit Until(const Expression& e) : Quantifier{e} {}
};

struct Query  {
	Quantifier quantifier;
	explicit Query(Quantifier q) : quantifier{std::move(q)} {}
};
struct Exists : Query {
	explicit Exists(const Quantifier& q) : Query{q} {}
};
struct Forall : Query {
	explicit Forall(const Quantifier& q) : Query{q} {}
};

#endif // TYPES_H
