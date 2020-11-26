#ifndef TYPES_H
#define TYPES_H
#include <string>
#include <utility>

/* Used for debugging */ 
template<typename T>
struct TypeStringable {
	virtual std::string GetTypeString() { return typeid(T).name(); }
};

struct Expression : TypeStringable<Expression> {
	std::string expression_string;
	explicit Expression(std::string  str) : expression_string{std::move(str)} {}
};

struct Literal : Expression, TypeStringable<Literal> { 
	explicit Literal(const std::string& str) : Expression{str} {}
};

struct VariableIdentifier : Expression, TypeStringable<VariableIdentifier> { 
	explicit VariableIdentifier(const std::string& str) : Expression{str} {}
};

struct LocationIdentifier : Expression, TypeStringable<LocationIdentifier> {
	explicit LocationIdentifier(const std::string& str) : Expression{str} {}
};

struct Deadlock : Expression, TypeStringable<Deadlock> { 
	explicit Deadlock(const std::string& str) : Expression{str} {}
};

struct LogicOperator : Expression, TypeStringable<LogicOperator> {
	enum struct OperatorType {
		AND, OR
	};
	OperatorType type;
	Expression left, right;
	static OperatorType FromString(const std::string& string) {
		printf("Implement me, please\n");
		return OperatorType::AND;
	}
	LogicOperator(const std::string& str, Expression l, Expression r) : Expression{str}, type{FromString(str)}, left{std::move(l)}, right{std::move(r)} {}
};

struct NegationOperator : Expression, TypeStringable<NegationOperator> {
	Expression subExpression;
	explicit NegationOperator(Expression sub) : Expression{"!"}, subExpression{std::move(sub)} {}
};

struct Comparator : Expression, TypeStringable<Comparator> {
	enum struct CompareType {
		LESSTHAN, LESSTHANEQUAL, NOTEQUAL, EQUAL, GREATERTHAN, GREATERTHANEQUAL
	};
	CompareType type;
	Expression left, right;
	static CompareType FromString(const std::string& string) {
		printf("Implement me, please\n");
		return CompareType::LESSTHAN;
	}
	Comparator(const std::string& str, Expression l, Expression r) : Expression{str}, type{FromString(str)}, left{std::move(l)}, right{std::move(r)} {}
};

/* LPAREN subexpr RPAREN */
struct SubExpression : Expression, TypeStringable<SubExpression> {
	Expression expr;
	SubExpression(const std::string& str, Expression e) : Expression{str}, expr{std::move(e)} {}
};

struct Quantifier : TypeStringable<Quantifier> { 
	Expression expression;
	explicit Quantifier(Expression e) : expression{std::move(e)} {}
};

struct Finally : Quantifier, TypeStringable<Finally> {
	explicit Finally(const Expression& e) : Quantifier{e} {}
};
struct Globally : Quantifier, TypeStringable<Globally> { 
	explicit Globally(const Expression& e) : Quantifier{e} {}
};
struct Next : Quantifier, TypeStringable<Next> { 
	explicit Next(const Expression& e) : Quantifier{e} {}
};
struct Until : Quantifier, TypeStringable<Until> { 
	explicit Until(const Expression& e) : Quantifier{e} {}
};

struct Query : TypeStringable<Query> { 
	Quantifier quantifier;
	explicit Query(Quantifier q) : quantifier{std::move(q)} {}
};
struct Exists : Query, TypeStringable<Exists> { 
	explicit Exists(const Quantifier& q) : Query{q} {}
};
struct Forall : Query, TypeStringable<Forall> { 
	explicit Forall(const Quantifier& q) : Query{q} {}
};

#endif // TYPES_H
