<?php

namespace App\Controller;

use App\Entity\Product; # ajouté
use Doctrine\ORM\EntityManagerInterface; # ajouté
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use App\Form\ProductType;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ProductController extends AbstractController
{
    #[Route('/products', name: 'product_list')] # remplacé /product par /products et app_product par product_list
    public function index(EntityManagerInterface $em): Response # remplacé index() par index(EntityManagerInterface $em)
    {
        $products = $em->getRepository(Product::class)->findAll(); # ajouté
        return $this->render('product/index.html.twig', [
            'products' => $products, # remplacé 'controller_name' => 'ProductController' par 'products' => $products
        ]);
    }

    #[Route('/product/new', name: 'product_new')]
    public function create(Request $request, EntityManagerInterface $em): Response
    {
        $product = new Product();

        // Crée le formulaire lié à l'entité Product
        $form = $this->createForm(ProductType::class, $product);

        // Traite la requête HTTP
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em->persist($product);
            $em->flush();

            $this->addFlash('success', 'Product created successfully!');

            // Redirige vers la liste des produits après ajout
            return $this->redirectToRoute('product_list');
        }

        // Affiche le formulaire dans la vue Twig
        return $this->render('product/new.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}
