function [] = plot_population(X)
    image(X);
    colormap([0 0 1 ; 1.0 0.6 0 ; 1 0 0]);
    hold on;
        for i = 1:(size(X,1)+1)
            plot((i-0.5)*[1 1] , [0.5 size(X,2)+0.5] , 'k');
        end
        for j = 1:(size(X,2)+1)
            plot([0.5 size(X,1)+0.5] , (j-0.5)*[1 1] , 'k');
        end
    hold off;
end
