(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
�  -Y �]Ys⺶����y�����U]u�	�`c�֭�g&cc~�1��3t҉w�j݉A��%�o-eI��>Y�Wn��!�ח )@����$��z��P-��4��(��_5�k���lm���_���N��˽��/��H����4��Ӄ�����SF���h���_ޒ�m
�+�b�c�c������|�Aup��Q�Ȯ�_.����^q��;.�?�V������>[ǩ��@�\�$Mӕ���5|�o'^���r�E�8
�"�;y?��{4%����|Q{�N�i�_+�V���3�i�v1w��<��)����L�4�:$a��"�#��>M��ڎG�.�">��d_5�*��2������I���/^P�_5��������ؐ՚�}P��	���S�4]h�(�H��&��I����V���l5�M[�Ta&��~ʧ1�<�j���@.6�&h!�S�J�MJO��<�Mt��h�C����@O�{<e��t�����24H���ֶޗ�.��P�Ȗ(z9�����;tj��
/=�?�ѿ)~i��^4]�~�~�1����0�Z�+�%�������ď����{����)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G��K�'��Q�S�M�G��?�.a��%�-�g�;���@=2̛흺_���@�8��В��X>̐#q���^B������
|Hʑ�z E�����di���2s��I���:��2��4]�!�l��b��p��#v�D���[�NyM1GkH���5q"5q1u{�����h�yl��W�y.�V��
������2t����[���˶:U �U��ք9P�m�0<Z GZoi�rf�m qy���+ ���TɌ�\�A����}� ����堛��>�u�^��[��kSR�G�D������:��u�E��`f����d_��8�#�f5�7�~�&��� 7ؽߤی�	��97�~&׵d:\M�6��C%�u���|����]�������d�Q
>E��9�}��G�bHT�_*����+��ϵ~A��;&�r�'�����_��W��T�_)�����_���O�N����W'�)�-~��); 	h�e0�u(��%�q�#�*��B����Y�EЕ�W.����=q�w4)h��Hc=A]f��\�������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=�������W��T��������?D���@��W��U���߇��W��T�_
>I���?#�����������ߛ9	�G(L���.@^����`�����%�~4kpl�L̇0�н�4��с
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��b�.u�A��U;Ǝ�Y�{�u�9Ҷxd\�ǈ�#}/8���sr��8m�<f	��i��� =����4�+qz��	'�h>Cm��LBDy�Z|g����haڳ'�&Te p�� j��a���ЬG����l�]wZ����Ҟ)-K�z��͎���#JH;#)ɜ�H^�n�@B�<�+���z�Z��|�����2�����|��??���+�/��_�������������#�.�A+�/������1����RP��������;����c[ A����+���ؤ�N?�0P>���v�����.�"K�$�"��"B�,J�$I�U���2�y�B�Xe�����T&��j�R��͉�1]0��cϑV�f?h�CO^��(���0�;uZI��!��h;��e>^�0�m�F9fl������#Bݞ��� ��|�q��g��Rrj��U�������~����(MT���������S�?��CU������2�p��q���)���$޾|Y9\.ǉJ�e�3���vЋ口R��-����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��z\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v��U���w��P�xj�Q^�e������K��*��2��������o���(o����_����΁X�qе
�%,�!?;�y<���%�������a�Ui��U��n�/���CwA�����h�� 菞=hZ�a��-
'���N����B�N{Ġ�7��j�66a�'�E�\�n�Y=�c�1<�j2�:�޼9��\�t���[q�\R|o6h&*�n�Q�z���b��G�y��p���s��i�X�s�%_���ԕsY�Hњ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>��nk�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i��Ń}��i;�����R�[��^����f��$�r~K�!�7��g�?�cHpe��������������k���;��4r�����>}�ǽ��O��|�o �my�>��} �Gܖ�^��}�4��r���=8"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�� ��B��<���]j�?6�Y�|�9���f-x6���nڷW�`�5��\��^J�r��{���,�C��z}��{���46a�Dw�h�"����������_:�r���*����?�,����S�b�W����!��������������_��W�����:�b�ð�������ܺ���1�(_���������\��-�
e�l�����Rp9�a�4��$J1E����>�Q$�8�N�8��(��S��庘�0^��[���a�������J����2%[N��95c����ͩ����-y#��E������Ds:n+� �Jx����^�����ط�ܱ
#Jj�9��uG� ?��]K'��@9���C�ި��Q��м���Qx�;��b�GI����h���x}���lz���������f���V���2?�N]?��j��/��4�C�[m�O�t�{a1�I��k�1�E\���5re/��}����N�x�����Z��&N���4�����.��Z�������8]g?����ķ���Ҋ��K�[-�Ԯ���O�Ż�])��Պ`��ko���yh?:����e�|��y�+�v�`���;���]y�.�ƋM�?�k��Sݾ��)n�{���K?�Y�Q1*\��2�(pk+܎����r�V��.[]]uQ�i�����MG��
A������ߋ��׾�WD���e�VQI��d�;j���y�av}�(�΢г/7�˃��������ś7K���Q��l/V`t�7E�p�xV{����ǒ�LZ�����q��q��Z�������۫��ݮ�����{�*�~����{,��-��JcK����y�Χ��ƛ��jp���0N���R���ƹ.T�O��#��k���O4a���"D~��j��Ծ���}�߀����,n{�柫�S���X�"��wu�oY廂x#�D~`����݁�=Z �˪����N7��dS)���ʪ�}����0<��5��S8�,�%u�=��O��b�S���=�*�������u���p�\υˡ��2f��{�t]�ҡ"]�n;]�ukO׵ۺ���;1AM�	&����?1�OJ�F��|P	4bD!&������l;g�p� ���=]�^����=���{�'�1F69_�)7�2�B�Y"� c���.������d&K]J�#�0�[۲vL@u�$uD���e8���V��i90���Xti1 ��f��O�9���mB�%�b¸�;�"�ʒ$�tpph|�m�5\����pr��5�!��L�nV)��8Z|ۀ��"&Y2b��h�n�ڨ�;VIp�><άW��w(IP�}F���H�t[��i��-���K��v��;ĻY�3n��2�`�g.��2{hJ#��U)�j�A�a�e����;��Cn��/��
��vI�Э����1�"���`��"yߢ�2@��S�(p�4��6�N}sp��/��������Ofw��h1�N�.�������U�*�z�̅��3���<'�Z����:��ӿ�e�M$�TҀő*�����#�é�e�猞N���"�9�eDi�ssW�kF���we>�W��k�ZS�*��n�9H3���E��ں��.2Y��<+e���)]����{�*wQ�h.P��Q�$
l����7��\sB�VWn�3Bs2��#���\���3�:�d4[PN�+�b��9���s�5D7r�I��6�sR�u�B��x���X��u��e���ۜ�i���i����Z;��O����\-VF�����l���ZT��ۅ�]��v�}�`�ՙ;pr*_ѫ��~8�4��F��QD��
���?�|@������V��q��d���?��������O��8x�Nl�Z{�ߏ��j絖J\x`���.��@�`,��E�U�uc�^�G�׳��V]����*���#��C9=�����Cgoo�vǙ_���ح��wO<����ڥG��9�
<C��J7����9�5�@8�C'��� ��š����9p�q��9���'��\���H�A���>=�Ծ�_���d}����Y�<0"�Ὠ�%�,ף��m��$^�0{����� ��a���6���e�z�����`#G$7C�6�%�n�3�,�Q��!�n�_��[��!��L��P;e��k`�4��Wɝ.��i2_�Q,S�׃���l���A�#pF��Ɇn�R�$�l����0GaJ����&j|?Mg��hG�X�)�A�/�����,
�L:;�+��f�(�ȄT*{j�l�G	�F)/�0,��-!&$=���,$�������C|��Ԕ'��z)D�!X.�G>e3am&�̈́]�	=} �n����E��Ԧ�:�Z�z�C�kvzK�.�����JȺUq0���h��d#n<(owœ�LR�n��2W��p_�#^���2A4�'Q��o5z��	%�L��6��|B"��CV�v�4�.�`�A"ԎdX��������+�CV�ل��l����A�
Amk�r<B�S�H��j���q�d%�U:�>�v�j�����D�@�)�apw=��cLd�m4�}e	��,ـuFY�ܙ�\w@
d���p*%����N488�������g�V4�v��6����P>�S-�IqJt���/B��ʠ
����g$:�%*B��*�h��1y<ӒRsʲGxFv��DU��h�7$	����V��9�`W'���p�I�8b*�`X-�;Q����J%#5?�k2�|�PM�}����
�ﭲ�)K����W��
�Ec=��|���Q�t�Y $(q����;)t�Z3�]���_I�|/5,��q%Z��vr�İR�������HLj�	 '܇S����I�A��j�,��7¤\�L�c�9e�#<#�TY��&��0��Ū�>-�T�{�,�+�k�%��7�p�9D���I��ɾ�T�6!�}�B�3#٤Ȗ#� ��$�����8m����l�m5�m�n�4'
�)��6�j�G�skWB�tJ�{b튍3�uӯ�V&A �.{�T�u��t��+��J�l�PUm���mN4B�r��]�v{]M���!T�����7�n�n7��+m\�F'7�7��B���j����AkSU]O�g���Ѳ��֡S�&K�%�ך��Ԇ<t3tz�?��s�هvX��:�,tf�*L~���d.��0�J���r��z]�Z�qL�gu�%3>1-3y��ʁ�;N㊢�Ũ�g�C/CF`Ō�C�C�.��DY5>�i�: �ڌ��?�#�_�[�ȍ������[����w˳_
엂�_
?p�-<���[$��3�.V�|+���le��}�AK	����Xt0�梃Ѡd�AO���`iς�Gu��I���iL7k� �=�w�{�1��7=4E��!�)5�Eҫz؈�EX)�E�@8R����hőh��~����WH�n!8�Ŕ�h^wn�u:�q%_�8Vh�c�rhd�:�����ᑠ�6���ӘI��ݣ&�C�±DM�05:D��g���ꪷC�fj9�i�:F��|>��O(�*q�2��T�q6�AZ��se�u�7�76���6D;�O�bB�%�[$��yյn��i
�$u�-��r�ǥ�V�c<��q8m㰍�6��X׮�t7t��T�2�\�6���c2�c�3���<�{�;t�[�2\��2����}���^���1�������ܗ�ò#i�Hڪ�Hf*8�6J�J)7p�K2�:�e؜�|�����b�KQ���`��>��D�Q�"�V�QPd�YS�՟c�w��Fm*	LL);q1D�A0�L��Ni��r&��tP8��Ѳ��/+]n�4��������/
�K)	�bB8Z��썅��Cvc!D����A���0!RcKM���pp�(O���nAy��._ڙ�+�Ŷ;"��|��R<���Byq�Y&�P�l�3� BW��B{���Ė��9@7Y����R.��t���V/�¾K;��a��a���q��q�F�Vr�܇v�fr��Z)$�B�m�"��ۅ�6e5��2m�õ;�-\���n�_G4�JE�5���^�\?���σ�q��$��-�M����Lw{}�\�W�Mҟ�I�t���^���G~��V�;>��/륧��]_z�/���q�Zc?�������f�ٴp��1�q ���]������%���g����Ko��� �x���M|󦿾��W�? z�$��8x*�~p�ڕޯ��䊞n��h:Q�m@g߈��O~�/6~'����_/��׿�'��)�����4E�|�	�9K�|զv��N��i�l��M����߿��i; mS;mj�M��}6�g{?P;ͷ��|�� U�B����z��&�&�A�-"�N21����L��1��=��_��^��&��<ۭ�y��T�S��3���6���gp��X���`9_�MM�Y�i�sf�h�=gƞ`O�����a�e�3s���G�s9f�\8�0�!Bk��6�]��1�9��_ju��b��Nv������M����`  