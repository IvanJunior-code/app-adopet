PGDMP         /                |         
   mydatabase %   14.12 (Ubuntu 14.12-0ubuntu0.22.04.1) %   14.12 (Ubuntu 14.12-0ubuntu0.22.04.1) 	    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                        0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16384 
   mydatabase    DATABASE     [   CREATE DATABASE mydatabase WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';
    DROP DATABASE mydatabase;
                postgres    false                        3079    16385 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false                       0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1259    16396    adopters    TABLE       CREATE TABLE public.adopters (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nome character varying(100) NOT NULL,
    email character varying(70) NOT NULL,
    senha character varying(255) NOT NULL,
    telefone character varying(15),
    cidade character varying(50),
    sobre character varying,
    "fotoPerfil" character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);
    DROP TABLE public.adopters;
       public         heap    postgres    false    2            �          0    16396    adopters 
   TABLE DATA           �   COPY public.adopters (id, nome, email, senha, telefone, cidade, sobre, "fotoPerfil", created_at, updated_at, deleted_at) FROM stdin;
    public          postgres    false    210   F
       o           2606    16405 '   adopters PK_a61836ed298b9de340bdd0e294a 
   CONSTRAINT     g   ALTER TABLE ONLY public.adopters
    ADD CONSTRAINT "PK_a61836ed298b9de340bdd0e294a" PRIMARY KEY (id);
 S   ALTER TABLE ONLY public.adopters DROP CONSTRAINT "PK_a61836ed298b9de340bdd0e294a";
       public            postgres    false    210            �   �  x��V�n�6=3_�(��D*���"�mݦǽ��Q�@UJ���P�����c�ή�݃/���yofޣ2��R�LJ�=jQy.2�[��B���]���}�>{
�q^~��ZL\�؈�#���6B�2���5E�3�����l���;�'�9�M���q@�@���ā{1��#�)�	{��a���\}��S�\2y��JiDZ�T]��*ϒT+��S�>�|a�E�t%@c!4� �u�+i!CmS�b���y�&��0	��-�!N���5a}=��=vCD�Ƕ9�0A��n����kx�����G�8vD�'��guh�3i�DF��hE�e�|�V�9v���܇�0��8ǚ�ؒe+&~�6�Bl^՛�N�?��?�;��6�8��&<�H�W���Y,����k4��a�tB�J̭2�g�=�ƥ��dد�4�[�(���fj*`��6����Z�ݱoGS@$�s�k�,
N`��8o��h�LThJ���a��%�Z��e���;�	�e���X�	.�W�7DF��->Dd?�q
�
��tx��L��D���p:��Y�Y�S�(|U���{���Hb��aw۶!��{�=��i&��?1���Dw���C�8R�~��?D���p�U^u�r9�p�5��"�"�kQ�iN�H_�Bg$�ݖԈ�b�aa���~���B�2�� �!��!tؼi�o���}g�W.sZed�����dAv`�K��
�/
/����R{��+��&�H����ÛF_hg��Xq͈�#yg��JK�E)���P��0+K�W5��d`P����X\J��c�β��k$$5�=����i�������7%��3,���9���*��K�Ô(��T��EQ)c��[�Lq�iN��.+��l���6�o�h��(vے�A��<�-b\������-w�W������׬΢�Crqq�/�5�     