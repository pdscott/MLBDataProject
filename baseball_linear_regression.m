% This script calculates linear regression predictions based on the player
% stats in baseballXY.mat
% Optionally it can add a strength of schedule component to the model which
% uses baseball_schedules.mat

load('baseballXY.mat')
load('baseball_schedules.mat')

trainX_zscore = zscore(trainX,[],1);
testX_zscore = zscore(testX,[],1);
[coeff_pca,score,latent,tsquared, explained] = pca(trainX_zscore);
trainX_pca12 = trainX_zscore * coeff_pca(:,1:12);
testX_pca12 = testX_zscore * coeff_pca(:,1:12);

%Initial training model (26 features)
model = fitlm(trainX_pca12, trainY);
plotAdded(model);

%Initial test using model on test data
test_pred_column = predict(model, testX_pca12);
test_pred = transpose(test_pred_column);
error = testY - test_pred_column;
error = power(error,2);
mse = sum(error)/30;
rmse = power(mse,0.5)

%stop here if not using strength of schedule feature

train_pred_2001 = zeros(1,30);
train_pred_2002 = zeros(1,30);
train_pred_2003 = zeros(1,30);
train_pred_2004 = zeros(1,30);
train_pred_2005 = zeros(1,30);
train_pred_2006 = zeros(1,30);
train_pred_2007 = zeros(1,30);
train_pred_2008 = zeros(1,30);
train_pred_2009 = zeros(1,30);
train_pred_2010 = zeros(1,30);
train_pred_2011 = zeros(1,30);
train_pred_2012 = zeros(1,30);
train_pred_2013 = zeros(1,30);


for i=1:30
    train_pred_2001(i) = model.Fitted(i);
    train_pred_2002(i) = model.Fitted(i+30);
    train_pred_2003(i) = model.Fitted(i+60);
    train_pred_2004(i) = model.Fitted(i+90);
    train_pred_2005(i) = model.Fitted(i+120);
    train_pred_2006(i) = model.Fitted(i+150);
    train_pred_2007(i) = model.Fitted(i+180);
    train_pred_2008(i) = model.Fitted(i+210);
    train_pred_2009(i) = model.Fitted(i+240);
    train_pred_2010(i) = model.Fitted(i+270);
    train_pred_2011(i) = model.Fitted(i+300);
    train_pred_2012(i) = model.Fitted(i+330);
    train_pred_2013(i) = model.Fitted(i+360);
end

sched_weightings = zeros(390,1);

row = 1;
for i=1:30
    sched_weightings(row) = (train_pred_2001 * sched2001(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2002 * sched2002(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2003 * sched2003(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2004 * sched2004(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2005 * sched2005(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2006 * sched2006(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2007 * sched2007(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2008 * sched2008(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2009 * sched2009(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2010 * sched2010(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2011 * sched2011(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2012 * sched2012(:,i));
    row = row + 1;
end
for i=1:30
    sched_weightings(row) = (train_pred_2013 * sched2013(:,i));
    row = row + 1;
end

%Add new feature to training set
trainX_weighted = [trainX,sched_weightings];

%recalculate training zscores
trainX_zscore_weighted = zscore(trainX_weighted,[],1);
[coeff_pca_w,score_w,latent_w,tsquared_w, explained_w] = pca(trainX_zscore_weighted);
trainX_pca12_weighted = trainX_zscore_weighted * coeff_pca_w(:,1:12);

%recalculate model
model_weighted = fitlm(trainX_pca12_weighted, trainY);
plotAdded(model_weighted);
%-----------------------------------------------
sched_weightings_test = zeros(30,1);
for i=1:30
    sched_weightings_test(i) = (test_pred * sched2014(:,i));
end
%Add new feature to test set
testX_weighted = [testX,sched_weightings_test];

%recalculate test zscores
testX_zscore_weighted = zscore(testX_weighted,[],1);
testX_pca12_weighted = testX_zscore_weighted * coeff_pca_w(:,1:12);

%redo predictions with new model
test_pred_weighted = predict(model_weighted, testX_pca12_weighted);
error_weighted = testY - test_pred_weighted;
error_weighted = power(error_weighted,2);
mse_weighted = sum(error_weighted)/30;
rmse_weighted = power(mse_weighted,0.5)

