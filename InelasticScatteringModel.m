[kFDTDx, kFDTDy] = meshgrid(kx);
[Kx, Ky] = meshgrid(kS);

f=49; %28.7 GHz

Ex = interp2(kFDTDx,kFDTDy,Ix',Kx,Ky);
Ey = interp2(kFDTDx,kFDTDy,Iy',Kx,Ky);
Ez = interp2(kFDTDx,kFDTDy,Iz',Kx,Ky);
clear signal

Filtersize = [1 1 1];

% FFTtruncX = smooth3(FFTtruncXB, 'gaussian', Filtersize)./1e8;
% FFTtruncY = smooth3(FFTtruncYB, 'gaussian', Filtersize)./1e8;
% FFTtruncZ = smooth3(FFTtruncZB, 'gaussian', Filtersize)./1e8;

FFTX = FFTtruncX(369/2-1:end-86, 369/2-1:end-86,:)./1e8;
FFTY = FFTtruncY(369/2-1:end-86, 369/2-1:end-86,:)./1e8;
FFTZ = FFTtruncZ(369/2-1:end-86, 369/2-1:end-86,:)./1e8;


index = 1:length(fS);
Signal = zeros(size(index));
for f = index
    IntX = 1i*Ez.*FFTY(:,:,f) - 1i*Ey.*FFTZ(:,:,f);
    IntY = -1i*Ez.*FFTX(:,:,f) + 1i*Ex.*FFTZ(:,:,f);
    IntZ = 1i*Ey.*FFTX(:,:,f) - 1i*Ex.*FFTY(:,:,f);

%     IntX = 1i*Ez.*FFTtruncY(:,:,f);
%     IntY = -1i*Ez.*FFTtruncX(:,:,f);
%     IntZ = 1i*Ey.*FFTtruncX(:,:,f) - 1i*Ex.*FFTtruncY(:,:,f);
%     IntZ = 0;
%     IntX = 0;
%     IntY = 0;
%     Int = (IntX.*conj(IntX) + IntY.*conj(IntY) + IntZ.*conj(IntZ));
    Int = (IntX + IntY + IntZ).*conj((IntX + IntY + IntZ));

    Signal(f) = squeeze(sum(sum(Int,1),2));
end

% Signal = (Signal/max(Signal))';
disp('Max signal is:');
disp(max(Signal(1:40)));
Signal = (Signal/max(Signal(1:40)));
plot(fS/1e9, Signal)
xlabel('Frequency (GHz)')
ylabel('BLS signal ()')
ylim([0 1])