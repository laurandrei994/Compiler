#include <stdio.h>
#include "node.h"
#include <stdlib.h>
#include "y.tab.h"

int yyparse();
extern int line_no;
extern FILE* yyin;

int main(int argc, char* argv[])
{
	FILE *file = fopen("out.txt", "w");
	fclose(file);
	yyin = fopen(argv[1], "r");
    yyparse();
	fclose(yyin);
	
    return 0;
}

int environment[32];

#define TRUE 1
#define FALSE 0

int visited[32]; // De la 2 la 29 // 26 variabile
int declared[32];

int accumulator1 = 28;
int accumulator2 = 29;
int accumulator3 = 30;

int getReserveRegistry()
{
	/* Parcurgem toti registrii si gasim unul gol */
    for (int i = 2; i < 32; ++i)
        if (FALSE == declared[i] && FALSE == visited[i])
            return i;
}


void Init()
{
    /* Mereu se declara */
    declared[accumulator1] = 1;
    declared[accumulator2] = 1;
    declared[accumulator3] = 1;
}

int registerIndex(char name)
{
    return name - 'a' + 2; // Primii 2 registrii sunt rezervati
}

int getFreeAccumulator()
{
    return visited[accumulator1] == FALSE ? accumulator1
         : visited[accumulator2] == FALSE ? accumulator2 
         : visited[accumulator3] == FALSE ? accumulator3 
         : -1;
}

void FreeAccumulators()
{
    visited[accumulator1] = FALSE;
    visited[accumulator2] = FALSE;
    visited[accumulator3] = FALSE;
}

int labelCounter = 0;

int isAssignment(int type)
{
    if ( '=' == type || TKN_PLUS_EQ == type || TKN_MULTIPLY_EQ == type || TKN_DIVISION_EQ == type || TKN_MINUS_EQ == type )
        return TRUE;
    return FALSE;
}



Operand Generate(Node* node) {
	FILE *yyout = fopen("out.txt", "a");
    switch(node->type) {
        case CONST:
        {   
            return (Operand) { VALUE, node->constant.value };
        }
        case ID:
        {
            return (Operand) { REG , registerIndex(node->id.name) };
        }
        case OPR:
        {
            switch(node->opr.type) 
            {
                case TKN_GREATER_EQ: // >=
                case TKN_LESS_EQ: // <=
                case TKN_EQ:  // ==
                case TKN_NOT_EQ: // !=
                case TKN_OR:  // ||
                case TKN_AND: // &&
                case TKN_PLUS_EQ: // +=
                case TKN_MINUS_EQ: // -=
                case TKN_MULTIPLY_EQ: // *=
                case TKN_DIVISION_EQ: // /*
                case '>':
                case '<':
                case '=':
                case '/':
                case '*':
                case '-':
                case '+': 
                {

                    Operand leftOperand = Generate(node->opr.operands[0]);
                    Operand rightOperand = Generate(node->opr.operands[1]);

                    int leftReg, rightReg;
                    int returnedValue; 	// Pentru un management al memoriei mai bun trebuie sa aflam valoarea returnata de expresie

                    if (VALUE == leftOperand.type)
                    {            
                        leftReg = getFreeAccumulator();

						/* Daca registrul este -1 atunci alegem unul din cei nefolositi pentru declararea variabilei */
                        if ( leftReg == -1 )
                            leftReg = getReserveRegistry();

                        fprintf(yyout,"li $%d %d\n", leftReg, leftOperand.data);
                        visited[leftReg] = TRUE;

						/* Nu putem avea o valoare la stanga unei atribuiri */
                        if ( TRUE == isAssignment(node->opr.type) )
                        {
                            puts("Error, value not expected for the leftOperand of a assignment");
                            exit(-1);
                        }

                    } 
                    else if (REG == leftOperand.type)
                    {
                        if (TRUE == declared[leftOperand.data])
                            leftReg = leftOperand.data;
                        else
                        {
                            puts("ERROR: Trying to use undeclared variable");
                            exit (-1);
                        }
                    }

                    
                    if (VALUE == rightOperand.type)
                    {
                        rightReg = getFreeAccumulator();

                        /* Daca registrul este -1 atunci alegem unul din cei nefolositi pentru declararea variabilei */
                        if ( rightReg == -1 )
                            rightReg = getReserveRegistry();

                        fprintf(yyout, "li $%d %d\n", rightReg, rightOperand.data);
                        visited[rightReg] = TRUE;
                    
                    } 
                    else if (REG == rightOperand.type)
                    {
                        if (TRUE == declared[rightOperand.data])
                            rightReg = rightOperand.data;
                        else
                        {
                            puts("ERROR: Trying to use undeclared variable %s");
                            exit (-1);
                        }
                    }

                    int enteredSwitch = TRUE;
                    int returnAcumul = getFreeAccumulator();

                    if (returnAcumul == -1)
                        returnAcumul = leftReg;

                    if (leftReg != returnAcumul)
                        visited[leftReg] = FALSE;
                    visited[returnAcumul] = TRUE;

					/* Mereu eliberam rightReg */
                    visited[rightReg] = FALSE;
                    
                    switch (node->opr.type)
                    {
                        case '-': fprintf(yyout, "sub $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);                            break;
                        case '+': fprintf(yyout, "add $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);                            break;
                        case '/': fprintf(yyout, "div $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);                            break;
                        case '*': fprintf(yyout, "mult $%d, $%d, $%d\n", returnAcumul, leftReg, rightReg);                            break;
                        case TKN_NOT_EQ: fprintf(yyout, "xor $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);                     break;
                        case TKN_OR : fprintf(yyout, "or $%d, $%d, $%d\n",   returnAcumul, leftReg, rightReg);                        break;
                        case TKN_AND: fprintf(yyout, "and $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);                        break;
                        case '<': fprintf(yyout, "slt $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);                            break;
                        case TKN_PLUS_EQ: fprintf(yyout, "add $%d, $%d $%d\n",   leftReg, leftReg, rightReg);                         break;
                        case TKN_MINUS_EQ: fprintf(yyout, "sub $%d, $%d, $%d\n",  leftReg, leftReg, rightReg);                        break;
                        case TKN_MULTIPLY_EQ: fprintf(yyout, "mult $%d, $%d, $%d\n", leftReg, leftReg, rightReg);					  break;
                        case TKN_DIVISION_EQ: fprintf(yyout, "div $%d, $%d, $%d\n",  leftReg, leftReg, rightReg);                     break;
                        case '=': fprintf(yyout, "li $%d, $%d\n",leftReg, rightReg);                                          		  break;
                        case TKN_EQ:  
                        {
							/* Punem un 0 in returnAcumul */
                            fprintf(yyout, "li $%d, 0\n", returnAcumul);
                            
							/* Verificam daca sunt egali sau nu folosind bne - branch on not equal */
                            fprintf(yyout, "bne $%d, $%d, L%d\n", leftReg, rightReg, labelCounter++);

							/* Daca sunt egali, atunci returnAcumul va fi egal cu 1 */
                            fprintf(yyout, "li $%d 1\n", returnAcumul);

							/* Afisam eticheta catre care va sari in cazul in care nu sunt egali */
                            fprintf(yyout, "L%d: \n", labelCounter - 1);

                            break;
                        }
                        case '>':
                        {
							/* Verificam daca este mai mare */
                            fprintf(yyout, "slt $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);

							/* Daca leftReg > rightReg mergem la urmatoarea eticheta (totul este ok) */
                            fprintf(yyout, "beq $%d, 1, L%d\n",  returnAcumul, labelCounter++);

							/* Daca nu este mai mare returnam 0 */
                            fprintf(yyout, "li $%d 0\n", returnAcumul);

							/* In final afisam eticheta */
                            fprintf(yyout, "L%d: \n", labelCounter - 1);

                            break;
                        }
                        case TKN_LESS_EQ:
                        {
							/* Verificam daca este mai mic */
                            fprintf(yyout, "slt $%d, $%d, $%d\n",  returnAcumul, leftReg, rightReg);

							/* Daca leftReg < rightReg mergem la urmatoarea eticheta (totul este ok) */
                            fprintf(yyout, "beq $%d, 1, L%d\n",  returnAcumul, labelCounter++);
    
							/* Setam la 1 in cazul in care sunt egali (daca totul va fi ok) */
                            fprintf(yyout, "li $%d, 1\n", returnAcumul);
                            
							/* Verificam daca sunt egali folosind beq */
                            fprintf(yyout, "beq $%d, $%d, L%d\n", leftReg, rightReg, labelCounter - 1);

							/* Daca nu este nici mai mic si nici egal atunci setam acumulatorul la 0 */
                            fprintf(yyout, "li $%d, 0\n", returnAcumul);

							/* In final afisam eticheta */
                            fprintf(yyout, "L%d: \n", labelCounter - 1);

                            break;
                        }
                        case TKN_GREATER_EQ:
                        {
							/* Verificam daca este mai mic */
                            fprintf(yyout, "slt $%d, $%d, $%d\n",  rightReg, leftReg, rightReg);

							/* Setam la 0, in cazul in care conditia nu este indeplinita */
                            fprintf(yyout, "li $%d, 0\n", returnAcumul);

							/* Daca leftReg < rightReg mergem la urmatoarea eticheta */
                            fprintf(yyout, "beq $%d, 1, L%d\n",  rightReg, labelCounter++);
    
							/* Setam la 1 in cazul in care sunt egali */
                            fprintf(yyout, "li $%d, 1\n", returnAcumul);
                            
                            /* In final afisam eticheta */
                            fprintf(yyout, "L%d: \n", labelCounter - 1);

                            break;
                        }
                        default: enteredSwitch = FALSE; break;
                    }
					
                    return (Operand) { REG, returnAcumul };
                }
                case TKN_INT:
                {
                    Operand value = Generate(node->opr.operands[0]);
                    
                    if ( FALSE == declared[value.data] )
                        declared[value.data] = TRUE;
                    else
                    {
                        puts("ERROR: Redeclaration of variable!");
                        exit(-1);
                    }

                    /* Daca avem si o expresie */
                    if (node->opr.noOfOpr == 2)
                    {    
                        Operand expr = Generate(node->opr.operands[1]);

                        if (VALUE == expr.type)
                            fprintf(yyout, "li $%d %d\n", value.data, expr.data);
                        else
                        {
                            fprintf(yyout, "li $%d $%d\n", value.data, expr.data);
                            declared[expr.data] = FALSE;
                        }
                    }
                                        
                    break;
                }
                case TKN_IF:
                {   
                    Operand eval = Generate(node->opr.operands[0]);
                    fprintf(yyout, "li $%d, 0\n", accumulator1);
                    visited[accumulator1] = FALSE;

                    fprintf(yyout, "beq $%d, $%d, L%d\n", eval.data, accumulator1, labelCounter);
                    int endLabel = ++labelCounter;
                    Generate(node->opr.operands[1]);
                    FreeAccumulators();
                    
                    /* Daca avem si ramura else, atunci avem 3 argumente */
                    if (node->opr.noOfOpr == 3)
                    {
                        fprintf(yyout, "j L%d \n", labelCounter);
                        fprintf(yyout, "L%d: \n", labelCounter - 1);
                        endLabel = ++labelCounter;
                        Generate(node->opr.operands[2]);
                        FreeAccumulators();
                        fprintf(yyout, "L%d: \n", endLabel - 1);
                    }
                    else
                    {
                        fprintf(yyout, "L%d: \n", endLabel - 1);
                    }
                    break;
                }
                case TKN_WHILE:
                {
                    /* Eticheta la care vom sari */
                    fprintf(yyout, "L%d: \n", labelCounter++);
                    
                    Operand eval = Generate(node->opr.operands[0]);
                    
                    fprintf(yyout, "li $%d, 0\n", accumulator1);
                    visited[accumulator1] = FALSE;
                    
                    if ( REG == eval.type)
                    {
                        fprintf(yyout, "beq $%d, $%d, L%d\n", eval.data, accumulator1, labelCounter);
                    }
                    else if ( VALUE == eval.type )
                    {
                        fprintf(yyout, "li $%d 1\n", accumulator2);
                        visited[accumulator2] = FALSE;

                        fprintf(yyout, "beq $%d, $%d, L%d\n", accumulator2, accumulator1, labelCounter);
                    }

                    int endLabel = labelCounter++;
                    Generate(node->opr.operands[1]);
                    FreeAccumulators();

                    fprintf(yyout, "j L%d \n", endLabel - 1);
                    fprintf(yyout, "L%d: \n", endLabel);

                    break;
                }
                case TKN_DO:
                {
                    /* Eticheta la care vom sari */
                    fprintf(yyout, "L%d: \n", labelCounter++);
                    
                    /* Generarea codului */
                    Generate(node->opr.operands[0]);
                    FreeAccumulators();

                    /* Conditia */
                    Operand eval = Generate(node->opr.operands[1]);
                    fprintf(yyout, "li $%d, 0\n", accumulator1);
                    visited[accumulator1] = FALSE;
                    
                    if ( REG == eval.type)
                    {
                        fprintf(yyout, "beq $%d, $%d, L%d\n", eval.data, accumulator1, labelCounter);
                    }
                    else if ( VALUE == eval.type )
                    {
                        fprintf(yyout, "li $%d 1\n", accumulator2);
                        visited[accumulator2] = FALSE;

                        fprintf(yyout, "beq $%d, $%d, L%d\n", accumulator2, accumulator1, labelCounter);
                    }

                    int endLabel = labelCounter++;
                   
                    /* In final mergem la eticheta precedenta */
                    fprintf(yyout, "j L%d \n", endLabel - 1);
                    fprintf(yyout, "L%d: \n", endLabel);

                    break;
                }
                case TKN_FOR:
                {
                    /* Eticheta la care vom sari */
                    fprintf(yyout, "L%d: \n", labelCounter++);
                    
                    /* Executarea primei expresii */
                    Operand exprToWrite = Generate(node->opr.operands[0]);
                    FreeAccumulators();

                    /* Verificarea conditiei din for */
                    Operand eval = Generate(node->opr.operands[1]);
                    
                    fprintf(yyout, "li $%d, 0\n", accumulator1);
                    visited[accumulator1] = FALSE;
                    
                    if ( REG == eval.type)
                    {
                        fprintf(yyout, "beq $%d, $%d, L%d\n", eval.data, accumulator1, labelCounter);
                    }
                    else if ( VALUE == eval.type )
                    {
                        fprintf(yyout, "li $%d 1\n", accumulator2);
                        visited[accumulator2] = FALSE;

                        fprintf(yyout, "beq $%d, $%d, L%d\n", accumulator2, accumulator1, labelCounter);
                    }

                    int endLabel = labelCounter++;

                    /* Generarea codului */
                    Generate(node->opr.operands[3]);
                    FreeAccumulators();

                    /* Generarea ultimei bucati din for */
                    Generate(node->opr.operands[2]);
                    FreeAccumulators();

                    /* In final, sarim la eticheta precedenta */
                    fprintf(yyout, "j L%d \n", endLabel - 1);
                    fprintf(yyout, "L%d: \n", endLabel);

                    break;
                }
                default: puts("Operator not implemented!, You should get to doing that soon!"); break;
            }
            break;
        }
	}
}