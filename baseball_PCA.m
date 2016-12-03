%This script calculates principle components for the feature set in 
% baseballXY.mat

load('baseballXY.mat')
C = corr(trainX, trainX);
trainX_zscore = zscore(trainX,[],1);
testX_zscore = zscore(testX,[],1);
[coeff_pca,score,latent,tsquared, explained] = pca(trainX_zscore);

trainX_cov = cov(trainX_zscore);

[evectors,evalues] = eig(trainX_cov);
e = eig(trainX_cov);


figure
ax1 = axes;
hold(ax1,'on');
plot(ax1,latent);
xlabel(ax1, 'Number of Principle Components');
ylabel(ax1, 'Variance');
box(ax1, 'on');
set(ax1, 'XGrid','on','YGrid','on');

figure()
pareto(explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')


numComponents = [2,4,6,8,10,12,14,16,18,20,22,24];
errorArray = [0,0,0,0,0,0,0,0,0,0,0,0];


for i=1:12
    trainX_pca = trainX_zscore * coeff_pca(:,1:numComponents(i));
    testX_pca = testX_zscore * coeff_pca(:,1:numComponents(i));
    model_pca = fitlm(trainX_pca, trainY);
    results_pca = predict(model_pca, testX_pca);
    error = testY - results_pca;
    error = power(error,2);
    mse = sum(error)/30;
    rmse = power(mse,0.5);
    errorArray(i) = rmse;
end
fprintf('Figure 1 shows Variance vs PC Number\n');
fprintf('Figure 2 shows Variance Explained vs PC Number\n');
fprintf('Figure 3 shows Error vs PC Number (also in table below)\n');
fprintf('#PC\tRMSE\n');
for i=1:12

    fprintf('%d\t%.2f\n', numComponents(i), errorArray(i));
end

figure
ax1 = axes;
hold(ax1,'on');
plot(numComponents, errorArray);
xlabel(ax1, 'Number of Principle Components');
ylabel(ax1, 'RMSE');
box(ax1, 'on');
set(ax1, 'XGrid','on','YGrid','on');

