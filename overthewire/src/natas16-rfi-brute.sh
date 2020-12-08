$(grep a /etc/natas_webpass/natas17) retornou do dict
$(grep A /etc/natas_webpass/natas17) não retornou nada

sempre que casa com a senha, ela é retornada e usada pelo grep da aplicação assin não casando com nada no dict.. 

se existe "African" char incorreto

grep -i -> para criar lista de chars
egrep ^ -> para ir testando uma a senha sendo concatenada
