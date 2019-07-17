

%  RECONHECIMENTO DE LIBRAS UTILIZANDO HU MOMENTS E CLASSIFICADOR SVM
%  Alunos: João e Fagner

vetLetras = ['A','B','C','D','E','F','G','I','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y'];
quant_letras = 22; % colocar 22
% Inicializando variáveis para conjunto de treino
letra = 'A';
num_folds = 6;
letraTeste = 'A_test';
extLetra= '.png';
dir_base = '..\Base_de_dados\Folds_Dataset_Final\';
total_imagens = quant_letras*num_folds*20; % 20 imagens por pasta de letra


contador_imagens = 0;

%--------------------------------------------------------------------------
%----------------------- TREINAMENTO DO MODELO ----------------------------
%--------------------------------------------------------------------------

%features
humoments_imagens = zeros(total_imagens,7);
%labels
etiquetas = zeros(total_imagens,1);

limiarBinario = 50;

for i = 1:num_folds
    msg= strcat('No fold numero:',num2str(i));
    disp(msg);
    
    % Constroi o caminho ate o diretorio das imagens de treino
    dir_fold = strcat(dir_base,'Fold',num2str(i),'\');
    
    for k = 1:quant_letras
        
        end_letra = strcat(dir_fold,vetLetras(k),'\');
        arquivos = dir([end_letra '*' extLetra]);
        
        % Começa a partir da metade da pasta, para que pegue apenas as
        % imagens binárias
        for j = ((size(arquivos)/2)+1):size(arquivos)

            % Faz a classificacao de cada imagem de treino
            img = imread([end_letra, arquivos(j,1).name]);
            %imshow(img);

                                        % ORGANIZAÇÃO DOS ARQUIVOS        

            contador_imagens = contador_imagens + 1;

            etiquetas(contador_imagens,1) = k; % posição com o número da letra

            humoments_imagens(contador_imagens,:) = humoments(img);

        end
    end
    
end


%------------------ SEPARAÇÃO DAS IMAGENS DE TESTE-------------------------

porcentagem_treino = 0.80;
porcentagem_teste = 1 - porcentagem_treino;
[treino, teste] = amostra(etiquetas, porcentagem_treino);

dados_treino = humoments_imagens(treino, :);
dados_teste = humoments_imagens(teste, :);

etiqueta_treino = etiquetas(treino);
etiqueta_teste = etiquetas(teste);

%--------------------------------------------------------------------------
%--------------------- CLASSIFICAÇÃO DAS IMAGENS ---------------------------
%--------------------------------------------------------------------------

classificacao = classify(dados_teste, dados_treino, etiqueta_treino);

acertos = zeros(quant_letras, 1);
erros = zeros(quant_letras, 1);

teste_final = ceil(contador_imagens*porcentagem_teste);
disp(teste_final);
for i = 1:teste_final

    if (classificacao(i) == etiqueta_teste(i)) % Acertou no teste
        acertos(etiqueta_teste(i)) = acertos(etiqueta_teste(i)) + 1; 
        %disp(label_test(i));
    else % Errou no teste
        erros(etiqueta_teste(i)) = erros(etiqueta_teste(i)) + 1;
    end

end

%Imprime o resultado final
for i = 1:quant_letras
  msg = strcat(vetLetras(i), ':', ' ', num2str(acertos(i)), '/', num2str(acertos(i)+erros(i)), '  ', '(', num2str((acertos(i)*100)/(acertos(i)+erros(i))), '%)');
  disp(msg);
end









