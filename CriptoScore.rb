print "Calculador de score para criptomoedas
                        por Milo Draco
                        v. 0.94\n"
loop do

# inputs
print "\nInsira o nome da moeda: "
name = (gets.chomp).upcase
file = File.new("criptoscore.log", 'a') # criando arquivo de texto
file.write(Time.now, "\n")
print "Insira o valor atual da moeda em R$: "
value = (gets.chomp).to_f
print "Insira o crescimento em % nos últimos 3 meses: "
c3 = (gets.chomp).to_f
print "Insira o crescimento em % nos últimos 6 meses: "
c6 = gets.chomp
print "Insira o crescimento em % nos últimos 12 meses: "
c12 = gets.chomp
if c6 == "" || c12 == ""
  nohist = true # sem histórico
  else
  nohist = false
end
c6 = c6.to_f
c12 = c12.to_f
print "Insira o saldo das dez últimas notícias (boas - ruins)
dentro dos últimos 3 meses: "
news = (gets.chomp).to_i
news = 10 if news > 10

# cálculos
svalue = Math.log(500000) - Math.log(value) # avaliação do valor unitário da moeda
if svalue > 10
  svalue = 10 + Math.sqrt(svalue-10)
  elsif svalue < 0
  svalue *= 2
end
if nohist == true # ajustando volatilidade caso não haja histórico
  volat = 10
  else
  volat = (((c3 * 2) - c6).abs + ((c6 * 2) - c12).abs)**0.25
end
fator = 5.5 + volat # fator divisor de acordo com a volatilidade para avaliação do crescimento
if fator < 7
  fator = 7.0
  elsif fator > 21
  fator = 21.0
end
cresc = ((c3 + c6 + c12)/fator).abs**(1/3.0) * 2 # avaliação do crescimento
cresc *= -1 if (c3+c6+c12)/fator < 0 # valores negativos
if c3 < c6/2.0 && c6 < c12/2.0
  dip = true # mergulho
  else
  dip = false
end
if c3 > c6/2.0 && c3 > c12/4.0
  climb = true # alto crescimento no último trimestre
  else
  climb = false
end
score = cresc + svalue + news - volat # avaliação final
if dip == true
  score -= ((c3 - (c6/2.0)) + (c6 - (c12/2.0))).abs**0.25 # penalidade em caso de mergulho
  elsif climb == true
  score += ((c3 - (c6/2.0)) + (c6 - (c12/2.0))).abs**(1/3.0) # bônus em caso de alto crescimento
end
score = score.round(2)

# resultado
print "\nValor: #{svalue.round(2)}"
if svalue > 10
  print " (excelente!)\n"
  elsif svalue > 7
  print " (bom)\n"
  elsif svalue > 4
  print " (razoável)\n"
  elsif svalue > 0
  print " (ruim)\n"
  else
  print " (muito ruim!)\n"
end
print "Crescimento: #{cresc.round(2)}"
if cresc > 15
  print " (excelente!)\n"
  elsif cresc > 10
  print " (bom)\n"
  elsif cresc > 5
  print " (razoável)\n"
  elsif cresc > 0
  print " (baixo)\n"
  elsif cresc == 0
  print " (nulo)\n"
  else
  print " (negativo!)\n"
end
print "Volatilidade: #{volat.round(2)}"
if volat > 10
  print " (muito alta!)\n"
  elsif volat > 7
  print " (alta)\n"
  elsif volat > 4
  print " (razoável)\n"
  elsif volat > 0
  print " (estável)\n"
  else
  print " (nula!)\n"
end
print "Notícias: #{news.round}"
if news >= 10
  print " (promissoras!)\n"
  elsif news >= 7
  print " (boas)\n"
  elsif news >= 4
  print " (razoáveis)\n"
  elsif news >= 0
  print " (ruins)\n"
  else
  print " (péssimas!)\n"
end
print "Alerta:"
if dip == true
  print " em declínio!\n"
  elsif climb == true
  print " tendência de alta!\n"
  else
  print " nenhum\n"
end
print "Score final: #{score}"
if score >= 30
  print result = " (investimento altamente recomendável!)"
  elsif score >= 20
  print result = " (investimento recomendável)"
  elsif score >= 10
  print result = " (razoável)"
  elsif score >= 5
  print result = " (duvidoso)"
  else
  print result = " (não recomendado!)"
end
print "\n"
file.write("#{name} (R$ #{value}): #{score}#{result}", "\n") # escrevendo log
print "\nCalcular outra criptomoeda? (s/n) "
lp = (gets.chomp).upcase
file.write("\n") if lp == "N"
exit if lp == "N"
end

# ajustar os cálculos para quando não houver o histórico completo de crescimento
# adicionar alertas de 'histórico incompleto' e 'saldo de notícias desconhecido'
# adicionar erro caso c3 seja vazio
