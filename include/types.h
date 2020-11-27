#ifndef TYPES_H
#define TYPES_H
#include <string>
#include <utility>

struct Visitor;
/* Visitable */
struct Visitable {
    virtual void accept(const Visitor& visitor) const = 0;
};

struct Visitor {
public:
    virtual void Print(const Visitable*) const = 0;
};


struct Expression : Visitable {
	std::string expression_string;
	explicit Expression(std::string  str) : expression_string{std::move(str)} {}
    virtual void accept(const Visitor& visitor) const = 0;
};

struct Literal : Expression {
	explicit Literal(const std::string& str) : Expression{str} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct VariableIdentifier : Expression {
    explicit VariableIdentifier(const std::string& str) : Expression{str} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct LocationIdentifier : Expression {
	explicit LocationIdentifier(const std::string& str) : Expression{str} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct Deadlock : Expression {
	explicit Deadlock(const std::string& str) : Expression{str} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct LogicOperator : Expression {
	enum struct OperatorType {
		AND, OR, UNKNOWN
	};
	OperatorType type;
	Expression* left,* right;
	static OperatorType FromString(const std::string& string) {
        if(string == "&&") return OperatorType::AND;
		if(string == "and")return OperatorType::AND;
		if(string == "||") return OperatorType::OR;
        if(string == "or") return OperatorType::OR;
		return OperatorType::UNKNOWN; // Something is very wrong, my dude
	}
	LogicOperator(const std::string& str, Expression* l, Expression* r) : Expression{str}, type{FromString(str)}, left{l}, right{r} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct NegationOperator : Expression {
	Expression* subExpression;
	explicit NegationOperator(Expression* sub) : Expression{"!"}, subExpression{sub} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct Comparator : Expression {
	enum struct CompareType {
		LESSTHAN, LESSTHANEQUAL, NOTEQUAL, EQUAL, GREATERTHAN, GREATERTHANEQUAL, UNKNOWN
	};
	CompareType type;
	Expression* left,* right;
	static CompareType FromString(const std::string& string) {
        if(string == "<") return CompareType::LESSTHAN;
        if(string == "<=") return CompareType::LESSTHANEQUAL;
        if(string == "!=") return CompareType::NOTEQUAL;
        if(string == "==") return CompareType::EQUAL;
        if(string == ">=") return CompareType::GREATERTHAN;
        if(string == ">") return CompareType::GREATERTHANEQUAL;
		return CompareType::UNKNOWN; // There is something very wrong, my dude
	}
	Comparator(const std::string& str, Expression* l, Expression* r) : Expression{str}, type{FromString(str)}, left{l}, right{r} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

/* LPAREN subexpr RPAREN */
struct SubExpression : Expression {
	Expression* expr;
	SubExpression(const std::string& str, Expression* e) : Expression{str}, expr{e} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct Quantifier : Visitable {
	Expression* expression;
	explicit Quantifier(Expression* e) : expression{e} {}
    virtual void accept(const Visitor& visitor) const = 0;
};

struct Finally : Quantifier {
	explicit Finally(Expression* e) : Quantifier{e} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};
struct Globally : Quantifier {
	explicit Globally(Expression* e) : Quantifier{e} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};
struct Next : Quantifier {
	explicit Next(Expression* e) : Quantifier{e} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};
struct Until : Quantifier {
	explicit Until(Expression* e) : Quantifier{e} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

struct Query : Visitable {
	Quantifier* quantifier;
	explicit Query(Quantifier* q) : quantifier{q} {}
    virtual void accept(const Visitor& visitor) const = 0;
};
struct Exists : Query {
	explicit Exists(Quantifier* q) : Query{q} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};
struct Forall : Query {
	explicit Forall(Quantifier* q) : Query{q} {}
    void accept(const Visitor& visitor) const override { visitor.Print(this); }
};

#endif // TYPES_H
