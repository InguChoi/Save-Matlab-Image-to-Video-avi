function Create_Only_Video_Func(metric)


    ImageLocation = uigetdir;

    %% Input Name

    prompt = {'Video File Name'};
    dlgtitle = 'Video File';
    definput = {'Image'};
    dims = [1 80];
    opts.Interpreter = 'tex';
    answer = inputdlg(prompt,dlgtitle,dims,definput,opts)

    %% Save Video

    imds = imageDatastore(ImageLocation);
    imgs = readall(imds);

    numberOfFrames = length(imgs);

    hFigure = figure;
    hFigure.Position = [100 100 1200 512];


    cnt = 0;
    DataTimeValue = [];
    q = [];

    videoFileName = append(char(answer), '.avi');

    v = VideoWriter(videoFileName);
    v.FrameRate = 60;

    open(v);

    for frameIndex = 10 : numberOfFrames

        cla reset;

        rawImage = imgs{frameIndex};
        subplot(1,2,1)
        imshow(rawImage); hold on;

        subplot(1,2,2)
        
        points = detectSURFFeatures(rawImage);

        hold on
       
        cnt = cnt + 1;
        
%         'Feature'
        if metric == 1
            pointsCount_Mat(cnt) = points.Count;
            plot(pointsCount_Mat)       
            ylabel('Feature Number')     
            
%         'Blur'
        elseif metric == 2
            blurScore = blurMetric(rawImage);
            pointsCount_Mat(cnt) = blurScore;
            plot(pointsCount_Mat)    
            ylabel('Blur Score')  

% https://stackoverflow.com/questions/34525897/extract-motion-blur-of-an-image-in-matlab             
        elseif metric == 3
            [lpOrigIm,~] =  imgradient(rawImage);
            nPx = round(0.001*numel(rawImage));
            sortedOrigIm = sort(lpOrigIm(:));
            measureOrigIm = median(sortedOrigIm(end-nPx+1:end));
            measureOrigIm_Mat(cnt) = measureOrigIm;

            plot(measureOrigIm_Mat)    
            ylabel('Blurriness')  
            
        elseif metric == 4
            
            [~,D,~] = svd(im2double(rawImage));
%         svdScore = 1 - sum(sum(D(1:10,1:10))) / sum(D(:));
%         svdScore = 1 - sum(sum(D(1:20,1:20))) / sum(D(:));
        svdScore = 1 - sum(sum(D(1:5,1:5))) / sum(D(:));
            
            svdScore_Mat(cnt) = svdScore;
            plot(svdScore_Mat)
            ylabel('SVD Score')
            
        elseif metric == 5
            
            score = brisque(rawImage);
            brisque_Mat(cnt) = score;
            plot(brisque_Mat)    
            ylabel('Brisque Score')  
            
        end

        xlabel('Frame Count')
        xlim([0, numberOfFrames])
        grid on

        drawnow;
        thisFrame = getframe(gcf);
        writeVideo(v, thisFrame);
        


    end


    close(v)


end

