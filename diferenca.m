
function img_num = diferenca(video, limiar)

% Função que separa os frames do vídeo de acordo com o limiar que capta a
% transição de uma letra para outra

    c = VideoReader(video);
    
    % Remove a borda preta dos frames
    rect = [42.5100, 33.5100, 236.9800, 174.9800];

    % Conta quantos frames o video tem
    quant_frames = 0;
    while hasFrame(c)
        readFrame(c);
        quant_frames = quant_frames+1;
    end

    % Le o video de novo para voltar pro primeiro frame
    v = VideoReader(video);

    % Divide o n de frames por dois (serao lidos de 2 em 2)
    max = floor(quant_frames/2);

    % Vetor das diferenças entre os pares de frames (pra plotar depois)
    dif = zeros(1,max);

    % Contador de imagens salvas (para o nome do arquivo)
    img_num = 0;

    for i = 1:max
        frame1 = readFrame(v);
        frame2 = readFrame(v);

        % Diferenca entre os dois frames
        imDiff = frame1 - frame2;
        imSum = frame1 + frame2;  
        percentDiff = 200 * mean(imDiff(:)) / mean(imSum(:));
        dif(i) = percentDiff;

        % Frames com pouca diferenca sao salvos
        if percentDiff <= limiar
            
            img_num = img_num + 1;
            
            % Remove a borda preta dos frames
            nimg = imcrop(frame1, rect);
            
            % Salva os frames
            nome_arquivo = strcat('./frames/', num2str(img_num), '.png');
            imwrite(nimg, nome_arquivo);
            
        end

        %figure();
        %imshow([frame1, frame2]);
        
    end

    %plot(dif);

end


